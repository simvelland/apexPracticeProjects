/* Future Apex
- Future Apex is used to run processes in a seperate thread, at a later time when the system resources become available.
- Future methods are typically used for:
    - callouts to external web services
    - operations you want to run in their own thread
    - Isolating DML operations on different sObject types to prevent the mixed DML error. 
- Future methods must be static methods, and can only return a void type. The specified parameters must be primitive data types or collections of primitive data types. Notably, future methods can’t take standard or custom objects as arguments. A common pattern is to pass the method a List of record IDs that you want to process asynchronously.
- To make a Web service callout to an external service or API, you create an Apex class with a future method that is marked with (callout=true)
- Test code cannot actually send callouts to external systems, so you’ll have to ‘mock’ the callout for test coverage
*/

Challenge 1

public class AccountProcessor {
    @future
    public static void countContacts(List<Id> accIds) {
        List<Account> accounts = [
            SELECT Id, (SELECT Id, FirstName, LastName FROM Contacts)
            FROM Account 
            WHERE Id IN :accIds
        ];

        List<Account> acctsToUpdate = new List<Account>();
        for (Account acc : accounts) {
            acc.Number_Of_Contacts = acc.Contacts.size();
            acctsToUpdate.add(acc);
        }

        update acctsToUpdate;
    }
}

@isTest 
public class AccountProcessorTest {
    
    @isTest
    public static void testNumberContactField() {
        Account newAccount = new Account(name = 'Count Contact Field Test');
        insert newAccount;
    
        Contact newContact = new Contact(
            FirstName = 'Count Contact',
            LastName = 'Test',
            AccountId = newAccount.Id
        );
        insert newContact;
    
        
        Test.startTest();
        AccountProcessor.countContacts(new List<Id>{ newAccount.Id });
        Test.stopTest();
        
        Account accCheck = [
            SELECT Id, Number_Of_Contacts__c
            FROM Account
            WHERE Id = :newAccount.Id
            LIMIT 1
        ];
    
        System.assertEquals(1, accCheck.Number_Of_Contacts__c);
    }
}


/* Batch Apex
- Make sure that the number of records inserted is less than or equal to the batch size of 200 because test methods can execute only one batch. You must also ensure that the Iterable returned by the start() method matches the batch size.
*/

Challenge 2

public class LeadProcessor implements Database.Batchable<SObject>, Database.Stateful {
    
    List<Lead> leadsToUpdate = new List<Lead>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
            SELECT Id 
            FROM Lead
        ]);
    }

    public void execute(Database.BatchableContext bc, List<Lead> scope) {
        for (Lead row : scope) {row.Leadsource = 'Dreamforce'; leadsToUpdate.add(row);}
    }

    public void finish(Database.BatchableContext bc) {
        update leadsToUpdate;
    }
}

@isTest
public class LeadProcessorTest {

    @isTest
    public static void testLeadProcessor() {
        List<Lead> leadsToInsert = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leadsToInsert.add(new Lead(
                LastName = 'Lead Processing Test',
                Company = 'MSH',
                Status = 'Open - Not Contacted'
            ));
        }

        insert leadsToInsert;

        Set<Id> insertedLeadIds = new Set<Id>();
        for (Lead item : leadsToInsert) {
            insertedLeadIds.add(item.Id);
        }

        Test.startTest();
        Database.executeBatch(new LeadProcessor());
        Test.stopTest();

        Boolean check = true;
        List<Lead> checklist = [
            SELECT Id, LeadSource 
            FROM Lead
            WHERE Id IN :insertedLeadIds
        ];

        for (Lead checkRow : checklist) {
            if (checkRow.LeadSource != 'Dreamforce') {check = false; break;}
        }
        System.assert(check);
    }
}

/* Queueable Apex 
- Queueable Apex allows you to submit jobs for asynchronous processing similar to future methods with the following additional benefits:
    - Non-primitive types
    - Monitroing
    - Chaining jobs
*/ 

Challenge 3

public class AddPrimaryContact implements Queueable {

    Contact primary; 
    String stateAbbreviation;

    public AddPrimaryContact(Contact c, String sa) {
        this.primary = c;
        this.stateAbbreviation = sa;
    }

    public void execute(QueueableContext qc) {
        
        List<Contact> contactsToInsert = new List<Contact>();
        for (Account acct : [
            SELECT Id 
            FROM Account
            WHERE BillingState = :stateAbbreviation
            LIMIT 200
        ]) {
            Contact cloneC = primary.clone(false, false, false, false, false);
            cloneC.AccountId = acct.Id;
            contactsToInsert.add(cloneC);
        }

        insert contactsToInsert;
    }
}

@isTest
public class AddPrimaryContactTest {

    @isTest
    public static void testAppPrimaryContactQueueable() {
        List<Account> accountsToInsert = new List<Account>();
        for (Integer i = 0; i < 50; i++) {
            accountsToInsert.add(new Account(
                Name = 'Test Add Orimary Contact Queeuable',
                BillingState = 'NY'
            ));
        }

        for (Integer i = 0; i < 50; i++) {
            accountsToInsert.add(new Account(
                Name = 'Test Add Orimary Contact Queeuable',
                BillingState = 'CA'
            ));
        }

        insert accountsToInsert;
        
        Set<Id> acctIds = new Set<Id>();
        for (Account acc : accountsToInsert) {
            acctIds.add(acc.Id);
        }

        Contact newContact = new Contact(
            FirstName = 'AddPrimaryContact',
            LastName = 'Test'
        );

        Test.startTest();
        AddPrimaryContact apc = new AccountPrimaryContact(newContact, 'CA');
        System.enqueueJob(apc);
        Test.stopTest();

        Integer numRecords = [
            SELECT Id
            FROM Contact 
            WHERE AccountId IN :acctIds AND FirstName = 'AddPrimaryContact' AND LastName = 'Test'
        ].size();

        System.assertEquals(50, numRecords);
    }
}

/* Apex Scheduler

- The Apex Scheduler lets you delay execution so that you can run Apex classes at a specified time. This is ideal for daily or weekly maintenance tasks using Batch Apex. 
- To take advantage of the scheduler, write an Apex class that implements the Schedulable interface, and then schedule it for execution on a specific schedule
- Schedule an instance of the class to run a specific time using the System.schedule() method
- After a class has been scheduled, a CronTrigger object is created that represents the scheduled job. It provides a getTriggerId() method that returns the ID of a CronTrigger API object. 
- The System.schedule() method uses the user's timezone for the basis of all schedules, but runs in system mode- all classes are executed, whether or not the user has permission to execute the class. 
- The System.schedule() method takes three arguments: a name for the job, a CRON expression used to represent the time and date the job is scheduled to run, and an instance of a class that implements the Schedulable interface.

*/ 

Challenge 4

public class DailyLeadProcessor implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        
        List<Lead> leadsToUpdate = new List<Lead>();
        for (Lead l : [
            SELECT Id, LeadSource
            FROM Lead
            WHERE LeadSource = null
            LIMIT 200
        ]) {
            l.LeadSource = 'Dreamforce';
            leadsToUpdate.add(l);
        }

        update leadsToUpdate;
    }
}

@isTest
public class DailyLeadProcessorTest {

    @isTest
    public static void testDailyLeadProcessor() {
        List<Lead> leadsToInsert = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leadsToInsert.add(new Lead(
                LastName = 'Daily Lead Processor Test',
                Company = 'MSH',
                Status = 'Open - Not Contacted'
            ));
        }
        insert leadsToInsert;
        
        Set<Id> leadIds = new Set<Id>();
        for (Lead l : leadsToInsert) {
            leadIds.add(l.Id);
        }

        Test.startTest();
        System.schedule('Daily lead processor test', '0 0 23 13 10 ?' , new DailyLeadProcessor());
        Test.stopTest();


        Boolean check = true;
        for (Lead l : [
            SELECT Id, LeadStatus
            FROM Lead
            WHERE Id IN :leadIds
        ]) {
            if (l.LeadStatus != 'Dreamforce') check = false;
        }

        System.assert(check);
    }
}

/* Monitor Asynchronous Apex
- Apex Jobs Page
- Apex Flex Queue
- CronTrigger
 */
