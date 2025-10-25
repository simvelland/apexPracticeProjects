/* Custom Metadata Types
- Metadata is data that describes other data. 
- Custom metadata type is an object that's used to define the structure for application metadata
- The fields of custom metadata types, and the values in the fields, consist only of metadata.
- The records of custom metadata types are also metadata, not data. 
- Using metadata is pretty handy because it can be imported into Salesforce, modified in the interface, and manipulated using the Metadata API.
-  Instead of storing hard-coded data, custom metadata types let you configure apps by building reusable functionality that determines the behavior based on metadata. And you can do much of this customization work using declarative tools.
- When you deploy apps with custom metadata types, all of the records and fields are included in the package installation, so no additional steps are needed. You can deploy custom metadata types from a sandbox with change sets or packaged in managed packages.
- Unlike custom metadata types, when you deploy apps with custom objects and custom settings, the metadata for those objects (the header) gets deployed, but the records (definitions) are left behind
- Handles list data. Doesn’t support hierarchy type data based on user, profile, or org level.
- Supports lookups between custom metadata types.
- Supports full CRU (create, read, update) operations in Apex. Delete isn’t supported.
- Use Cases: 
    - Mappings: You can use custom metadata types to create associations between different objects. For example, you can create a custom metadata type that assigns cities, states, or provinces to particular regions in a country.
    - Business Rules: Salesforce has lots of ways to define business rules. One way is to combine configuration records with custom functionality. For example, you can use custom metadata types along with some Apex code to route payments to the correct endpoint.
    - Primary data: : Say that your org uses a standard accounting app. You can create a custom metadata type that defines custom charges, like duties and VAT rates. If you include this type as part of an extension package, subscriber orgs can reference this primary data.
- Custom metadata types support most standard field types, including:
    Metadata Relationships
    Checkbox
    Date and Date/Time
    Email and Phone
    Number
    Percent
    Picklist
    Text and Text Area
    URL
- Developers can use SOQL to read custom metadata types. To create or update metadata records, they can use the Metadata API. Apex code can create, read, and update (but not delete) custom metadata records.
- Custom metadata types can be used directly from:
    Apex
    Flows
    Formula fields
    Validation rules

- Combined with custom metadata types, formulas eliminate the need for hardcoded values that you need to individually update. 
*/