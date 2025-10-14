/* 
Enfore sharing Rules:
- Apex generally runs in system context
- You can use sharing rules to extend a user's access to specific records, and then enfore sharing rules by using the with sharing keyword on a class declaration.

Enforce Object and Field Permissions
- To enfore FLS and object permissions of the current user, you can enforce user mode for database operations and SOQL queries. 

Enfore User Mode for Database Operations
- You can run database operations in user mode rather than in the default system mode by using SOQL or SOSL queries with special keywords or by using DML method overloads. 

Enforce Secuirity with the stripInaccessible Method
- Use the stripInaccessible method to enfore field-level and object-level data protection. This method can be used to strip the fields and relationship fields from query and subquery results that the user can;t access. 
- The method can also be used to remove inaccessible sObject fields before DML operations to avoid exceptions and to sanitize sObjects that have been deserialized from an untrusted source. 

Filter SOQL Queries Using with SECURITY_ENFORCED
- Use the WITH SECURITY_ENFORCED clause to enable field- and object-level security permissions checking for SOQL SELECT queries in Apex code, including subqueries and cross-object relationships. 
*/ 