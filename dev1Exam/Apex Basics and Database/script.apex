// APEX

Challenge 1:

public class StringListTest {

    public static List<String> generateStringList(Integer n) {
        List<String> outputList = new List<String>();
        for (Integer i = 0; i < n; i++) {
            outputList.add('Test ' + i);
        }

        return outputList;
    }
}


/* Manipulate Records with DML

- Each DML statement accepts either a single sObject or a list (or array) of sObjects. Operating on a list of sObjects is a more efficient way for processing records.
- upsert DML statement creates new records and updates sObject records within a single statement, using a specified field to determine the presence of existing objects, or the ID field if no field is specified.
- Upsert uses the sObject record's primary key (the ID), an idLookup field, or an external ID field to determine whether it should create a new record or update an existing one
- Deleted records aren;t immediately deleted from the Lightning Platform; they stay 15 days in the recyle bin. 
- Apex contains the built-in Database class, which provides methods that perform DML operations and mirror the DML statement counterparts (insert, update, upsert, delete, undelete, merge)
- DML operations execute within a transaction. All DML operations in a transaction either complete successfully, or if an error occurs in one operation, the entire transaction is rolled back and no data is committed to the database
*/

Challenge 2

public class AccountHandler {
    public static Account insertNewAccount(String name) {
        try {
            Account acc = new Account(Name = name);
            insert acc;
            return acc;
        } catch (DmlException e) {
            System.debug('Error occurred: ' + e.getMessage());
            return null;
        }
    }
}

// - SOQL for loops use a different method for retrieving records; records are retrieved using efficient chunking with calls to the query and queryMore methods of the SOAP API. 

Challenge 3

public class ContactSearch {
    public static List<Contact> searchForContacts(String lastName, String postalCode) {
        List<Contact> matchingContacts = [
            SELECT Id, Name 
            FROM Contact
            WHERE LastName = :lastName AND MailingPostalCode = :postalCode
        ]; 

        return matchingContacts; 
    }
}

// SOSL queries in APEX return Lists of Lists of SObjects
// SearchGroup can take ALL FIELDS, NAME FIELDS, EMAIL FIELDS, PHONE FIELDS, SIDEBAR FIELDS

public class ContactAndLeadSearch {
    public static List<List<SObject>> searchContactsAndLeads(String name) {
        List<List<SObject>> nameSearch = [FIND :name IN ALL FIELDS RETURNING Contact(FirstName, LAstName), Lead(FirstName, LastName)];
        return nameSearch;
    }
}