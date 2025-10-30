/* 
Mashups
- One approach to reducing the amount of data in Salesforce is to maintain large data sets in a different application, and then make that application available to Salesforce as needed
- Salesforce refers to such an arrangement as a mashup because it provides a quick, loosely coupled integration of the two applications.
- Mashups use Salesforce presentation to display Salesforce-hosted data and externally hosted data.
- Salesforce supports the following mashup designs:
    - External Website
    - Callouts
- Advantages of using mashups
    - Data is never stale
    - no proprietary method needs to be developed to integrate the two systems
- Disadvantages
    - Accessing data takes more time
    - functionality is reduced


Defer Sharing Calculation
- allows users to defer the processing of sharing rules until after new users, rules, and other content have been loaded.
- An organization’s administrator can use a defer sharing calculation permission to suspend and resume sharing calculations, and to manage two processes: group membership calculation and sharing rule calculation. 
- The administrator can suspend these calculations when performing a large number of configuration changes, which might lead to very long sharing rule evaluations or timeouts, and resume calculations during an organization’s maintenance period.
- This deferral can help users process a large number of sharing-related configuration changes quickly during working hours, and then let the recalculation process run overnight between business days or over a weekend.


Using SOQL and SOSL
- When a given search can use either language, SOSL is generally faster than SOQL if the search expression uses a CONTAINS term.
- SOSL can tokenize multiple terms within a field (for example, multiple words separated by spaces) and builds a search index off this. If you’re searching for a specific distinct term that you know exists within a field, you might find SOSL is faster than SOQL for these searches. 
- In some cases, when multiple WHERE filters are being used in SOQL, indexes can’t be used even though the fields in the WHERE clause can be indexed. In this situation, decompose the single query into multiple queries, each of which should have one WHERE filter, and then combine the results.


Deleting Data
- The Salesforce data deletion mechanism can have a profound effect on the performance of large data volumes. 
- Salesforce uses a Recycle Bin metaphor for data that users delete. Instead of removing the data, Salesforce flags the data as deleted and makes it visible through the Recycle Bin. This process is called soft deletion.
- While the data is soft deleted, it still affects database performance because the data is still resident, and deleted records have to be excluded from any queries.
- The data stays in the Recycle Bin for 15 days, or until the Recycle Bin grows to a specific size. The data is then hard deleted from the database after 15 days; when the size limit is reached; or when the Recycle Bin is emptied using the UI, the API, or Apex.
- In addition, Bulk API and Bulk API 2.0 support a hard delete option, which allows records to bypass the Recycle Bin and become immediately available for deletion.
- We recommend that you use the Bulk API 2.0’s hard delete function to delete large data volumes.
