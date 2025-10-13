// Choosing the Right Search Solution
- All records are stored as data fields in the org's database. 
- When you update or create a record, the search engine comes along, makes a copy of the data, and breaks up the content into smaller pieces called tokens. 
- These tokens are stored in the search index, along with a link back to the original record.
- The search index and tokens allow the search engine to apply advanced features like spell correction, nicknames, lemmatization, and synonym groups. All this means we can present records that include variations on the user's search term to widen the net of results. 
- The search index also provides the opportunity to introduce relevance ranking into the mix. This is how search finds and ranks the records users are looking for. 
- Things like search term frequency, order, and uniqueness; record activity; access permissions; and a handful of other factors. 
- Both SOQL and SOSL format text queries in a given API. Howeever, 
    - A SOQL query searches the org database. 
    - SOSL is a programmatic way of perforimg a text-based search against the search index. SOSL uses all the great, previously mentioned features of the search index. 

// Build Search for Common Use Cases


// Optimize Search Results
- To limit which data is searched us IN. You can search for name, email, phone, sidebar, or all fields. 
- Use Returning FieldSpec to specify which data is returned. You can use ObjectTypeName, FieldList, ORDER By, LIMIT, OFFSET
- You can also use WITH DIVISION, WITH DATA CATEGORY, WITH NETWORK, WITH PRICEBOOK