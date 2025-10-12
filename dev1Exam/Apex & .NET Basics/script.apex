Lightning Platform Basics
- relies on metadata-driven architecture. Everything, including the code, configuration, and apps, is specified as Metadata
- All variables in Apex are initialized to null by default
- Apex is not case sensitive
- Apex only has three types of collections: List, Map, Set
- Each standard or custom object in the database has a "mystical" representation via an Apex class that provides all sorts of functionality to make interacting with the database a snap. 
- The class and its underlying object are essentially a mirror image of one another that is constantly in sync.
- You can create and expose web services using the Apex programming language, as well as invoke external web services from Apex. 
- Salesforce offers both SOAP and REST APIs that provide direct access to the data in your org. 

public class AccountUtils {
    
    public static List<Account> accountsByState(String state) {
        List<Account> accountsToReturn = [
            SELECT Id, Name
            FROM Account
            WHERE BillingState = :state
        ];
        
        return accountsToReturn;
    }
}

// Understand Execution Context

- Code executes within an execution context; this context represents the time between when the code is executed and when it ends. 
- By default, Apex executes in system context, which means it has access to all objects and fields- object permissions, field-level security, and sharing rules aren't applied for the current user. 

trigger AccountTrigger on Account (before insert) {
    
    if (Trigger.isBefore && Trigger.isInsert) {
        AccountTriggerHandler.CreateAccounts(Trigger.New);
    }
}

public class AccountTriggerHandler {
    
    public static void CreateAccounts(List<Account> accounts) {
        for (Account acc : accounts) {
            acc.ShippingState = acc.BillingState;
        }
    }    
}

@isTest
public class AccountTriggerTest {
    
    @isTest
    public static void testTriggerFunction() {
        
        List<Account> acctsToInsert = new List<Account>();
        for (Integer i = 0; i < 200; i++) {
            Account newAcc = new Account(
                Name = 'Billing State Test ' + i,
                BillingState = 'CA'
            );
            acctsToInsert.add(newAcc);
        }
        
        Test.startTest();
        
        insert acctsToInsert;
        
        Test.stopTest();
        
        Set<Id> ids = new Set<Id>();
        for (Account a : acctsToInsert) ids.add(a.Id);
        
        List<Account> inserted = [
            SELECT Id, BillingState, ShippingState
            FROM Account
            WHERE Id IN :ids
        ];
        
        for (Account a : inserted) {
            System.assertEquals('CA', a.ShippingState);
        }
    }
}

// Use Asynchronous Apex

Reasons: 
- Processing a very large number of records
- Making callouts to external web services
- Creating a better and faster user experience


