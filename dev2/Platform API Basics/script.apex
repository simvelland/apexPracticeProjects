/* 
- API-first approach to feature development means building a robust API for a feature before focusing on designing its UI. This approach gives you flexibility to manipulate your data however you want. 
- Commonly used APIs:
    - REST
        - web service based on RESTful principles
        - exposes all sorts of SF functionality via REST resources and HTTP methods. 
        - you can CRUD records, search or query your data, retrieve object metadata, and access information about limits in your org
        - supports both XML and JSON
        - lightweight request and response framework
    - SOAP
        - web service based on the industry-standard protocol
        - uses a Web Service Description Language (WSDL) file to regorously define the parameters for accessing data through the API. 
        - suppots XML only
        - great for writing server-to-server integrations
    - Bulk
        - specialized RESTful API for loading and querying lots of data at once.
        - asynchronous, meaning that you can submit a request and come back later for the results
    - Pub/Sub
        - for integrating external systems with real-time events
        - subscribe to real-time events that trigger when changes are made to your data or subscribe to custom events
        - The APIs use a publish-subscribe, or pub/sub, model in which users can subscribe to channels that broadcast data changes or custom notifications.
        - reduces the number of API requests by eliminating the need for making frequent API requests to get data.
- Together, they make up the Salesforce data APIs. Their purpose is to let you manipulate your SF data or subscribe to data changes, whereas other APIs let you do things like customize page layputs or build custom development tools. 

- All API calls, except for the SOAP API login() call, require authentication. You can either use one of the supported OAuth flows or authenticate with a session ID retrieved from the SOAP API login() call.
- Salesforce limits the number of API calls per org to ensure the health of the instance. These limits exist to prevent rogue code from monopolizing  shared resources in the multitenant environment. 
- There are three types of API limits: timeout limits, concurrent request limits, and total request allocations. 
    - Timeout limits restrict the length of time a single call is allowed to run. 
    - Concurrent limits cap the number of long-running calls that are running at one time. Concurrent limits vary by org type. For example, trial orgs and production orgs have a different limit on cuncurrent requests. 
    - Total limits cap the number of calls made within a rolling 24-hour period. Total limits vary by org edition and license type, including any add-on licenses you purchase. Total limits are also subject to minimums and maximums based on the org edition. 

- You have several ways to check your remaining API calls:
    The API Usage box on the System Overview page. (From Setup, enter System Overview in the Quick Find box, then select System Overview.)
    Information returned in the Sforce-Limit-Info response header for REST APIs.
    Information returned in the response body (in <type>API REQUESTS</type>) for SOAP APIs.
    The /limits call in the REST API.
    The API Request Limit per Month usage-based entitlement, which shows you your org’s API calls aggregated over 30 days.

- When to use REST API
    - Its advantages include ease of integration and development, and it’s an excellent choice of technology for use with mobile applications and web projects
    - To build UI for creating, reading, updating, and deleting records, including building UI for list views, actions, and dependent picklists, use User Interface API.
    - To work with B2B Commerce, CMS managed content, Experience Cloud sites, and Chatter, use Connect REST API.
    - If you have many records to process, consider using Bulk API, which is based on REST principles and optimized for large sets of data.

- When to use SOAP API
    - You can use SOAP API to create, retrieve, update, or delete records
    - You can also use SOAP API to perform searches and much more
    - Use SOAP API in any language that supports web services.
    
- When to use Connect REST API
    - Connect REST API provides programmatic access to B2B Commerce, CMS managed content, Experience Cloud sites, files, notifications, topics, and more. 
    - Use Connect REST API to build UI for Chatter, such as feeds, users, and groups, especially in mobile applications.

- When to use UI API
    - Build user interfaces that let users work with records, list views, actions, favorites, and more. 
    - Not only do you get data and metadata in a single response, but the response matches metadata changes made to the org by Salesforce admins.

- When to use the Analytics REST API
    - You can access Analytics assets—such as datasets, lenses, and dashboards—programmatically using the Analytics REST API.

- When to use Bulk API
    - Bulk API is based on REST principles and is optimized for loading or deleting large sets of data.
    - You can use it to query, queryAll, insert, update, upsert, or delete many records asynchronously by submitting batches
    - Salesforce processes batches in the background.
    - SOAP API, in contrast, is optimized for real-time client applications that update a few records at a time. 
    - You can use SOAP API for processing many records, but when the data sets contain hundreds of thousands of records, SOAP API is less practical.
    - Bulk API is designed to make it simple to process data from a few thousand to millions of records.
    - The easiest way to use Bulk API is to enable it for processing records in Data Loader using CSV files. Using Data Loader avoids the need to write your own client application.

- When to use Metadata API
    - Use Metadata API to retrieve, deploy, create, update, or delete customizations for your org
    - The most common use is to migrate changes from a sandbox or testing org to your production environment
    - Metadata API is intended for managing customizations and for building tools that can manage the metadata model, not the data itself.
    - The easiest way to access the functionality in Metadata API is to use the Salesforce Extensions for Visual Studio Code or the Ant Migration Tool.
    - The easiest way to access the functionality in Metadata API is to use the Salesforce Extensions for Visual Studio Code or the Ant Migration Tool.

- When to use Pub/Sub API
    - You can use Pub/Sub API to integrate external systems with real-time events. 
    - Streams of data are based on custom payloads through platform events or changes in Salesforce records through Change Data Capture. 
    - Within Salesforce, you can publish and subscribe to events with Apex triggers, Process Builder, and Flow Builder. 
    - Pub/Sub API is built for high scale, bi-directional event integration with Salesforce
    - Use Pub/Sub API to efficiently publish and subscribe to binary event messages in the Apache Avro format
    -  Pub/Sub API is based on gRPC and HTTP/2 and uses a pull-based model so you can control the subscription flow. With Pub/Sub API, you can use one of the 11 programming languages that gRPC supports. 

- When to use Apex REST API
    - Use Apex REST API when you want to expose your Apex classes and methods so that external applications can access your code through REST architecture. 
    - Apex REST API supports both OAuth 2.0 and Session ID for authentication.

- When to use Apex SOAP API
    - Use Apex SOAP API when you want to expose Apex methods as SOAP web service APIs so that external applications can access your code through SOAP. 
    - Apex SOAP API supports both OAuth 2.0 and Session ID for authentication.

- When to use Tooling API
    - To build custom development tools or apps for Platform applications
    - For example, you can use Tooling API to add features and functionality to your existing Platform tools and build dynamic modules into your enterprise integration tools. 
    - You can also use Tooling API to build specialized development tools for a specific application or service
    - Tooling API’s SOQL capabilities for many metadata types allow you to retrieve smaller pieces of metadata. Smaller retrieves improve performance, making Tooling API a good fit for developing interactive applications.
    - Tooling API provides SOAP and REST interfaces.

- When to use GraphQL API
    - Build highly responsive and scalable apps by returning only the data a client needs, all in a single request
    - GraphQL API overcomes the challenges posed by traditional REST APIs through field selection, resource aggregation, and schema introspection. 
    - Field selection reduces the size of the payload, sending back only fields that were included in the query.
    - Aggregations reduce round trips between the client and server, returning a set of related resources within a single response. 
    - Schema introspection enables a user to see the types, fields, and objects that the user has access to.

- REST Resources and Methods
    - A REST resource is an abstraction of a piece of information or an action, such as a single data record, a collection of records, or a query. 
    - Each resource in REST API is identified by a named Uniform Resource Identifier (URI) and is accessed using standard HTTP methods (HEAD, GET, POST, PATCH, DELETE). 
    - REST API is based on the usage of resources, their URIs, and the links between them. 
    - You use a resource to interact with your Salesforce org. For example, you can:
        - Retrieve summary information about the API versions available to you
        - Obtain detailed information about a SF object
        - Perform a query or search
        - Update or delete records
    - A REST request consists of four components: 
        - a resource URI
        - an HTTP method
        - request headers
            - specify metadata for the request
        - request body
            - specifies data for the request
    - You can make REST requests from any HTTP sender, like Postman

- Enterprise and Partner WSDLs
    - Web Services Description Language (WSDL) file is a map to understanding how to use the API. It contains the bindings, protocols, and objects to make API calls. 
    - Salesforc eprovides two SOAP API WSDLs for two different use cases; 
        - The enterprise WSDL is optimized for a single Salesforce org. It's strongly typed, and it reflects your org's specific configuration, meaning that two enterprise WSDL files generated from two different orgs contain different information
        - the partner WSDL is optimized for use with many Salesforce orgs. It's loosely typed and it does't change based on an org's specific configuration. 
    

- Bulk API and Asychronous Requests
    - based on REST principles and is optimized for working with large sets of data. 
    - Use it to insert, update, upsert, or delete many records asynchronously, meaning that you submit a request and come back for the results later
    - Salesforce processes the request in the background
    - In contrast, SOAP and REST API use synchronous requests and are optimized for real-time client applications that update a few records at a time. 

- Pub/Sub API
    - enables you to subscribe to real-time event streams and integrate external systems with real-time events
    - Event streams are based on custom payloads through platfrom events or changes in Salesforce records through Change Data Capture
    - You can publish and subscribe to events with Apex triggers, Process Builder, and Flow Builder
    - built for high scale, bi-directional event integration with Salesforce. 
    - Use Pub/Sub API to efficiently publish and subscribe to binary event messages in the Apache Avro format
    - Tracking data changes in Salesforce is especially useful when you have business data stored in a system external to Salesforce. You can use Pub/Sub API to keep your external source in sync with your Salesforce data with change data capture events
    - Also, the API lets you process business logic in an external system in response to data changes in Salesforce. For example, you can use Pub/Sub API to notify a fulfillment center whenever an opportunity is updated.
    - In addition to data changes, you can use Pub/Sub API to send custom notifications with platform events. For example, an app can generate platform event notifications for orders that an order fulfillment service processes. Or an app can listen to platform events that Salesforce publishes to monitor user activity in Salesforce. 
    - These are the events you can publish and subscribe to:
        - Change Data Capture
            - you get changes of records of all supported changed fields
            - record operations tracked include CRUDU
            - Each event message contains header fields with information about the change
        - Platform Events
            - You can publish and subscribe to custom notifications
            - you can define the schema of the event data by creating platform event objects and fields
            - you can subscribe to standard platform events that are defined and published by Salesforce, such as real-time Event Monitoring events, to monitor user- and secuirty-related actifvity in Salesforce and other things. 
    - All the event products make use of the event bus, which is a service that enables the storage and retrieval of event messages
    - Platform Events and Change Data Capture offer flexibility, scalability, and enhanced security
        - You can subscribe to platform events and change data capture events with Apex triggers. In addition, platform events support subscription with flows and processes.
        - They support encryption at rest of event data.
        - The versioned schema of a platform event or change data capture event enables subscribers to deterministically parse events. Each schema version corresponds to a unique schema ID, which is included in the event notification message.
        - Change Data Capture includes header fields that contain information about the change.
    - Subscribers retrieve events from a channel on the event bus, including past events that are stored temporarily. The event bus decouples event publishers from event subscribers. 
    - Salesforce stores high-volume platform events and change data capture events for 72 hours. Retrieving stored event messages from the event bus enables you to catch up on missed events when the client was disconnected.
    - Each event message is assigned an opaque ID contained in the ReplayId field. The ReplayId field value, which is populated by the system when the event is delivered to subscribers, refers to the position of the event in the event stream. Replay ID values are not guaranteed to be contiguous for consecutive events.
    - A subscriber can store a replay ID value and use it on resubscription to retrieve events that are within the retention window. For example, a subscriber can retrieve missed events after a connection failure. Subscribers must not compute new replay IDs based on a stored replay ID to refer to other events in the stream.
    - 