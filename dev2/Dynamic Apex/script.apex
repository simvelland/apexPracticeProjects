/* 
- enable developers to create more flexible applications by providing them with the ability to: 
    - Access sObject and field describe information
        - Describe information provides metadata information about sObject and field properties. 
        - For example, the describe information for an sObject includes whether that type of sObject supports operations like create or undelete, the sObject's name and label, the sObject's fields and child objects, and so on.
        - The describe information for a field includes whether the field has a default value, whether it is a calculated field, the type of the field, and so on.
    - Access Salesforce app information
        - You can obtain describe information for standard and custom apps available in the Salesforce user interface. Each app corresponds to a collection of tabs.
        - Describe information for an app includes the app’s label, namespace, and tabs. Describe information for a tab includes the sObject associated with the tab, tab icons and colors.
    - Write Dynamic SOQL queries, dynamic SOSL queries, and dynamic DML
        - Dynamic SOQL and SOSL queries provide the ability to execute SOQL or SOSL as a string at runtime
        - dynamic DML provides the ability to create a record dynamically and then insert it into the database using DML
        - Using dynamic SOQL, SOSL, and DML, an application can be tailored precisely to the organization as well as the user's permissions. This can be useful for applications that are installed from AppExchange.
    
- Field and SObject tokens:
    - s.getsObjectType() == Account.sObjectType
    - Schema.DescribeSObjectResult dsr = Account.sObjectType.getDescribe()
    - Schema.DescribeFieldResult dfr = Schema.sObjectType.Account.fields.Name
    - dfr.getSObjectField == Account.Name
    - dfr = dfr.getSObjectField.getDescribe
    - Schema.sObjectType t = Account.sObjectType
    - Account a = new Account() => Schema.sObjectType t = a.getSObjectType()
    - Schema.DescribeSObjectResult dsr = Account.sObjectType.getDescribe();
    - Schema.DescribeSObjectResult dsr = Schema.SObjectType.Account;
    - Schema.SObjectField fieldToken = Account.Description
    - Schema.DescribeFieldResult dfr = Account.Description.getDescribe()
    - Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Account.fields.getMap();
    - String[] types = new String[]{'Account', 'Merchandise__c'};  =>  Schema.DescribeSObjectResult[] results = Schema.describeSObjects(types);

- getDescribeOnApps
    - Get tab set describes for each app: List<Schema.DescribeTabSetResult> tabSetDesc = Schema.describeTabs();
    - List<Schema.DescribeTabResult> tabDesc = tsr.getTabs();

- Accessing All sObjects
    - Use the Schema getGlobalDescribe method to return a map that represents the relationship between all sObject names (keys) to sObject tokens (values)
    - Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

- Accessing All Data Categories Associated with an sObject
    - Use the describeDataCategoryGroups and describeDataCategoryGroupStructures methods to return the categories associated with a specific object:

- Dynamic SOQL
    - Dynamic SOQL refers to the creation of a SOQL string at run time with Apex code. Dynamic SOQL enables you to create more flexible applications. For example, you can create a search based on input from an end user or update records with varying field names.
    - To create a dynamic SOQL query at run time, use the Database.query or Database.queryWithBinds methods
    - sObject s = Database.query(string);
    - List<sObject> sobjList = Database.query(string);
    - List<sObject> sobjList = Database.queryWithBinds(string, bindVariablesMap, accessLevel);
    - The Database.query and Database.queryWithBinds methods can be used wherever an inline SOQL query can be used, such as in regular assignment statements and for loops. The results are processed in much the same way as static SOQL queries are processed.
    - use the accessLevel parameter to run the query operation in user or system mode. The accessLevel parameter specifies whether the method runs in system mode (AccessLevel.SYSTEM_MODE) or user mode (AccessLevel.USER_MODE). 
    - use the Database.queryWithBinds method. With this method, bind variables in the query are resolved from a Map parameter directly with a key, rather than from Apex code variables. This removes the need for the variables to be in scope when the query is executed. 
    - Map<String, Object> acctBinds = new Map<String, Object>{'acctName' => 'Acme Corporation'};
        List<Account> accts = 
            Database.queryWithBinds('SELECT Id FROM Account WHERE Name = :acctName',
                                    acctBinds, 
                                    AccessLevel.USER_MODE);
    - Although map keys of type String are case-sensitive,the queryWithBinds method doesn’t support Map keys that differ only in case. In a queryWithBinds method, comparison of Map keys is case-insensitive. If duplicate Map keys exist, the method throws a runtime QueryException. 
    - Database.countQuery and Database.countQueryWithBinds: Return the number of records that a dynamic SOQL query would return when executed.
    - Database.getQueryLocator and Database.getQueryLocatorWithBinds: Create a QueryLocator object used in batch Apex or Visualforce.
    - To prevent SOQL injection, use the escapeSingleQuotes method. This method adds the escape character (\) to all single quotation marks in a string that is passed in from a user. The method ensures that all single quotation marks are treated as enclosing strings, instead of database commands.

- Dynamic SOSL
    - Dynamic SOSL refers to the creation of a SOSL string at run time with Apex code. Dynamic SOSL enables you to create more flexible applications. 
    - List<List <sObject>> myQuery = search.query(SOSL_search_string);
    - The search query method can be used wherever an inline SOSL query can be used, such as in regular assignment statements and for loops. The results are processed in much the same way as static SOSL queries are processed.
    - To provide more context for records in search results, use the SOSL WITH SNIPPET clause. Snippets make it easier to identify the content you’re looking for. 
    - To use the SOSL WITH SNIPPET clause in a dynamic SOSL query at run time, use the Search.find method.

- Dynamic DML
    - In addition to querying describe information and building SOQL queries at runtime, you can also create sObjects dynamically, and insert them into the database using DML.
    - To create a new sObject of a given type, use the newSObject method on an sObject token. Note that the token must be cast into a concrete sObject type (such as Account). 
    - You can also specify an ID with newSObject to create an sObject that references an existing record that you can update later.
    - Use the get and put methods on an object to set or retrieve values for fields using either the API name of the field expressed as a String, or the field's token.
    - Apex supports populating foreign keys by name (or external ID) in the same way as the API. To set or retrieve the scalar ID value of a foreign key, use the get or put methods.
    - To set or retrieve the record associated with a foreign key, use the getSObject and putSObject methods. Note that these methods must be used with the sObject data type, not Object.
    - SObject c = 
        Database.query('SELECT Id, FirstName, AccountId, Account.Name FROM Contact LIMIT 1');
        SObject a = c.getSObject('Account');
    - 