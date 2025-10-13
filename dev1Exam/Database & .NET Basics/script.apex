// Move from SWL to SOQL
- Object have built-in support for features such as access management, validation, formulas, and history tracking. 
- SOQL is used only to perform queries with the SELECT statement. 
- Child to Parent: use Dot notation 
- Parent to child: use nested query with plural child relationship name 
- Aggregate functions: AVG(), COUNT(), COUNT_DISTINCT(), MIN(), MAX(), SUM()
- aliasing only works for aggregate queries that use the GROUP BY clause.
- Having clause lets you filter records returned by aggregate function 

// SOSL
- perfrom text-based queries across multiple sObjects 
- Uses the FIND keyword
- the FIND clause is required; it's what makes the SOSL search unique, and its followed by whatever search term you're looking for, whether it's a single word or phrase 
- use the IN clause to specify a search group; it tells Salesforce which fields to search 
- use the RETURNING clause to specify which data to return and which objects to search. 
- if you specify an object name without a field name in parentheses, the search returns only the ID for that object if a match is found 
- SOSL is most useful when you don't know the exact fields and objects that your data resides in, and you need to search across multiple objects. This is especially true when those objects aren't related because SOQL works only with related objects. 

// Writing Efficient Queries
- The number 1 thing that can crash a system faster than anything a is a poorly performing query. 
- Salesoforce's back-end database uses Oracle, but Salesforce uses its own version of a Query Optimizer to evaluate cost-based queries
- Like most cost-based query optimizers, the one that Salesforce uses relies on statistics gathered about the data. Most statistics are gathered weekly, but the system also generates pre-queries that are cached every hour. 
- Power fields are indexed, meaning they make queries faster. 

// Modify records with DML
- In Apex, you can execute DML statements in two ways: using the statement itself, or using the Database class methods (advantage is using the allOrNone parameter to specify whether the operation can partially succeed)