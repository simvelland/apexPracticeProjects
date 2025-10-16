/* Writing Secure Apex Controllers

-  By default, Apex classes code executes in system mode and has the ability to read and update all data within an organization. Therefore, you must enforce sharing rules, set object and field permissions, and protect against CRUD and FLS violations. 
- There are three keywords to remember for sharing rules. You use the with sharing or without sharing keywords on a class to specify whether sharing rules must be enforced. You use the inherited sharing keyword on an Apex class to run the class in the sharing mode of the class that called it.
- The only exception to how Apex runs in system context, is Apex code executed with the executeAnonymous call and Chatter in Apex. The executeAnonymouscall always executes using the full permissions of the current user.
- The with sharing keyword lets you specify that the sharing rules for the current user are enforced for the class. You have to explicitly opt into this keyword for the class as a blank sharing clause on a class means that sharing settings are inherited from the caller, which may or may not enforce sharing.
- You use the without sharing keywords when declaring a class to ensure that the sharing rules for the current user are not enforced. For example, you can explicitly turn off sharing rule enforcement when a class is called from another class that is declared using with sharing.
- An Apex class without an explicit sharing declaration has an unknown enforcement of sharing rules as it depends on the sharing enforcement of the caller. 
- Indeterminate sharing enforcement is a security anti-pattern, and should be avoided if at all possible
- Executing data operations in user mode ensures that sharing rules, CRUD, and FLS permissions are respected and enforced.
- You can integrate the WITH SECURITY_ENFORCED clause into your SOQL SELECT queries within Apex code to validate field- and object-level security permissions automatically. This functionality extends to subqueries and cross-object relationships, streamlining query operations and technical intricacies.
- You can also enforce object-level and field-level permissions in your code by explicitly calling the sObject describe result methods (of Schema.DescribeSObjectResult) and the field describe result methods (ofSchema.DescribeFieldResult) that check the current user's access permission levels. In this way, you can verify if the current user has the necessary permission and only if they do, can you perform a specific DML operation or query.
- For example, you can call the isAccessible,isCreateable, or isUpdateable methods of Schema.DescribeSObjectResult to verify whether the current user has read, create, or update access to an sObject, respectively. Similarly, Schema.DescribeFieldResult exposes these access control methods that you can call to check the current user’s read, create, or update access for a field. In addition, you can call theisDeletable method provided by Schema.DescribeSObjectResultto check if the current user has permission to delete a specific sObject.
- You use thestripInaccessiblemethod to enforce field- and object-level data protection. This method can be used to strip the fields and relationship fields from query and subquery results that the user can’t access. The method can also be used to remove inaccessible sObject fields before DML operations to avoid exceptions and to sanitize sObjects that have been deserialized from an untrusted source.

*/

/* Mitigate SOQL Injection

- The first and most recommended method to prevent SOQL injection is to use static queries with bind variables.
- Another strategy to prevent SOQL injection is to use typecasting. By casting all variables as strings, user input can drift outside of expectation. By typecasting variables as integers or Booleans, when applicable, erroneous user input is not permitted. 
- Another cross-site scripting (XSS) mitigation option that is commonly used by developers who include user-controlled strings in their queries is the platform-provided escape function string.escapeSingleQuotes().
- A final tool in your tool belt is character replacement, also known as blocklisting. This approach removes “bad characters” from user input.
- Another way to prevent SOQL injection without string.escapeSingleQuotes()is allowlisting. Create a list of all “known good” values that the user is allowed to supply. If the user enters anything else, you reject the response.

*/

/* Mitigate Cross-Site Request Forgery

- CSRF is a common web application vulnerability where a malicious application causes a user's client to perform an unwanted action on a trusted site for which the user is currently authenticated. 
- Salesforce includes out-of-the-box protections against CSRF for developers.
- By default, requests made against Salesforce resources have CSRF tokens attached. These pseudo-random tokens prevent the reuse and distribution of hyperlinks to protect privileged accounts from accidentally making state-changing requests that were not intended.
- The most simple forms of CSRF attacks use HTTP GET requests with state-changing parameters, like GET mywebsite.com?change_username=”joe”. By simply avoiding the use of state-changing HTTP GET requests, you can eliminate a large number of CSRF vulnerabilities in your code. When you reach out to a web API, use POST or PUT instead when state changes are needed.
- When an endpoint is hit in your API, you can validate the origin header. The origin header is set on HTTP GET requests and specifies the URL from which a request originated. Suppose the request is on the forbidden headers list, meaning all major browsers will not allow it to be spoofed via JavaScript. In that case, it will always return the correct value unless the request initiates from a nonstandard browser or tool.
- Another place for CSRF vulnerabilities is when server-side DML operations are executed automatically as part of a page-loading event such as onInit or afterRender. To mitigate the risk of a page load CSRF, ensure that DML operations are only performed as a result of an interaction with a page (clicking a button, selecting an option, or other actions).

*/

/* Mitigate Server Side Request Forgery

- Server-side request forgery (SSRF) is a security vulnerability in web applications where an attacker can make unauthorized requests, both internal and external, on behalf of the server. In an SSRF attack, the malicious application tricks the server into making requests to internal and external services or systems, potentially leading to unauthorized access or data exposure.

*/

