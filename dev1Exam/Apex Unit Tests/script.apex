/* Apex Tests
- Before you can deploy your code or package it for the Salesforce AppExchange, at least 75% of Apex code must be covered by tests, and all those tests must pass. In addition, each trigger must have some coverage. Even though code coverage is a requirement for deployment, don’t write tests only to meet this requirement. Make sure to test the common use cases in your app, including positive and negative test cases, and bulk and single-record processing.
- Apex test classes are annotated with the @isTest annotation. Test classes can be defined with either private or public access modifiers. If you’re using a test class for unit testing only, declare it as private. Public test classes are typically used for test data factory classes, which we’ll cover in the Create Test Data for Apex Tests unit. Classes defined as @isTest must be top-level classes.
- Within the test class, test methods are also defined using the @isTest annotation.The visibility of a test method doesn’t matter, so declaring a test method as public or private doesn’t make a difference, as the testing framework is always able to access test methods. For this reason, the access modifiers are omitted in the method syntax.
- A test suite is a collection of Apex test classes that you run together. For example, create a suite of tests that you run every time you prepare for a deployment or Salesforce releases a new version. Set up a test suite in the Developer Console to define a set of test classes that you execute together regularly.
- Salesforce records that are created in test methods aren’t committed to the database. They’re rolled back when the test finishes execution. This rollback behavior is handy for testing because you don’t have to clean up your test data after the test executes.
- You can use Salesforce Apex Extension for Visual Studio Code to run Apex tests and verify the functionality of your code.
- You can save up to 6 MB of Apex code in each org. Test classes annotated with @isTest don’t count toward this limit.
- Even though test data rolls back, no separate database is used for testing. As a result, for some sObjects that have fields with unique constraints, inserting duplicate sObject records results in an error.
- Test methods don’t send emails.
- Test methods can’t make callouts to external services. You can use mock callouts in tests.
- SOSL searches performed in a test return empty results. To ensure predictable results, use Test.setFixedSearchResults() to define the records to be returned by the search.
*/ 

Challenge 1

@isTest
public class TestVerifyDate {
    @isTest
    static void testVerifyDateClass() {
        Date date1 = Date.newInstance(2025, 08, 15);
        Date date2 = Date.newInstance(2025, 08, 19);
        Date date3 = Date.newInstance(2025, 10, 11);
        
        Test.startTest();
        Date returnDate1 = VerifyDate.CheckDates(date1, date2);
        Date returnDate2 = VerifyDate.CheckDates(date1, date3);
        Test.stopTest();

        System.assertEquals(date2, returnDate1);
        System.assertNotEquals(date3, returnDate2);
    }
}

Challenge 2

@isTest
public class TestRestrictContactByName {
    @isTest
    static void testRestriction() {
        Contact newContact = new Contact(
            LastName = 'INVALIDNAME'
        );

        String message;

        Test.startTest();
        try {
            Database.saveResult result = Database.insert(newContact);
        } catch (DmlException e) {
            message = e.getMessage();
        }
        Test.stopTest();

        System.assert(message.contains('The Last Name "INVALIDNAME" is not allowed for DML'));
    }
}


Challenge 3

public class RandomContactFactory {
    public static List<Contact> generateRandomContacts(Integer num, String lastName) {
        List<Contact> contactsToInsert = new List<Contact>();
        for (Integer i = 0; i < num; i++) {
            Contact newC = new Contact(
                FirstName = 'Test ' + i,
                LastName = lastName 
            );
            contactsToInsert.add(newC);
        }

        return contactsToInsert;
    }
}