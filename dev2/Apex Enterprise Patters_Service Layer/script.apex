/* Understanding Separation of Concerns

- SOC requires some upfront thinking about the internal plumbing of your application, including class naming conventions and coding guidelines.
- At a high level, applications have three things: storage, logic, and a means to interact with them, whether by humans, woodland creatures or other applications. 
- When you separate these things, you can start to define layers within your application, each with its own set of concerns and responsibilities to other layers and the application as a whole. 
- Evolution. Over time, as technology, understandings, and requirements (both functional and technical) evolve, a layer might need to be extended, reworked, or even dropped. Take a look at UI technology over the past 10 years as a prime example. How many JavaScript frameworks can you count before passing out?
- Impact management. Modifying or dropping one or more layers should not unduly impact other layers, unless this is the intention due to requirements.
- Roles and responsibility. Each layer has its own responsibility and must not drop below or over-extend that responsibility. For example, dropping one client technology or library in favor of another does not mean losing business logic, because this is the responsibility of another layer. If the lines of responsibility get blurred, the purpose and value of SOC are eroded and that's not good.
- Presentation:
    - Declarative: Layouts, Record Pages, Flows, Record Types, Formulas, Reports, Dashboards
    - Coding: Apex Controllers, Visualforce, Lightning Components
- Business Logic Layer:
    - Declarative: Formula, Flow, Validation Rules, Sharing Rules, Approval Processes
    - Coding: Apex Services, Apex Cusstom Actions, Asynchronous Apex
- Data Access Layer
    - Declarative: Data Loaders, Salesforce Connect
    - Coding: SOQL, SOSL, Salesforce APIs
- Database Layer
    - Declarative: Custom Objects, Fields, Relationships, Rollups
    - Coding: Apex Triggers
- When to Use SOC on Salesforce
    - Replacing or adding another UI to your app — Consider how much code you need to rewrite or port that has nothing to do with the UI but affects your app’s inserting, updating, validating and calculating functionality.
    - Providing a public-facing API to your logic — Assess which parts of your existing code base you would call to implement the API. Is using your @AuraEnabled methods a good basis for an API? (The answer is no.)
    - Scaling your application logic via Batch Apex — If you need to continue to provide an interactive experience (for smaller volumes) via your existing UI, how would you share logic between the two to ensure that the user gets consistent results regardless of the size?
    - Working with complex logic in your Visualforce controllers or @AuraEnabled methods — Does any of your code deal with more than just handling information to and from the user? With Visualforce and Lightning Components, you can partition your code via Model–view–controller (MVC), a form of SOC for client development. However using controllers for all your code does not guarantee that you are following SOC in terms of your business logic.
    - Making it easy for new developers to find their way around your code base — How much time does a developer need to learn where to put new code and find existing behavior?
- Service layer, "Defines an application's boundary with a layer of services that establishes a set of available operations and coordinates the application's response in each operation."
- Design Considerations
    - Naming Conventions: abstract enough to be meaningful to a number of clients
    - Platform/Caller sympathy: Design method signatures that support the platform's best practices, especially bulkification. 
    - SOC considerations: service layer code encapsulates task or process logic typically utilizing multiple objects in your application. 
    - Security: sercive layer code and the code it calls should by default run with user security applied. 
    - Marshalling: Avoid prescribing how aspects of interacting with the service layer are handled because certain aspects are better left to the callers of your service, for example, semantics like error handling and messaging. 
    - Compund services: although clients can execute multiple service calls one after the another, doing so can be inefficient and cause database transactional issues. It's better to create compound services that internally group multiple service calls together in one service call. 
    - Transaction management and statelessness: Clients of the servcice layer often have different requirements regarding the longevity of the process being undertaken and the information being managed. Given these variations on state management, it's best to encapsulate database operations and service state within the method call to the service layer. In other words, make the service stateless to give calling contexts the flexibility to employ their own state management solutions. The scope of a transaction with the database should also be contained within each service method so that the caller does not have to consider this with its own SavePoints, for example. 
    - Configuration: You might have common configuration or behavioral overrides in a service layer, such as providing control to allow the client to instruct the server layer not to commit changes or send emails. Be sure to consider how you implement this consistently, perhaps as a method overload that takes a shared Options parameter, similar to the DML methods in Apex. 
    - Services can use the factory pattern along with Apex interfaces to dynamically resolve the implementation as opposed to coding it directly in the methods. This approach is useful for giving more flexibility in engineering the scope of tests around services. 
    - However, factories require some plumbing and framework to create interfaces, ways to register classes, and other fun stuff in your code.
    - Investing in a service layer for your application offers the engineering benefits of greater reuse and adaptability, as well as provides a cleaner and more cost effective way of implementing an API for your application, a must in today’s cloud-integrated world.
    - By closely observing the encapsulation and design considerations described above, you start to form a durable core for your application that will endure and remain a solid investment throughout the ever-changing and innovative times ahead!

Apply Service Layer Principles in Apex
    - If you’re using a full encapsulation of the database and state management, one implementation approach is to use an appropriately named class with static methods representing the operations of the service.
    - The methods in your class represent the service operations, which access the information they need through the environment and parameters passed. 
    - The logic in the method updates the database or returns information in the method’s return type using custom Apex exceptions to indicate failure. 
*/
public with sharing class OpportunitiesService {
   public static void applyDiscounts(Set<Id> opportunityIds, Decimal discountPercentage) {
        // Validate parameters
        if(opportunityIds==null || opportunityIds.size()==0)
            throw new OpportunityServiceException('Opportunities not specified.');
        if(discountPercentage<0 || discountPercentage>100)
            throw new OpportunityServiceException('Invalid discount to apply.');
        // Query Opportunities and Lines (SOQL inlined for this example, see Selector pattern in later module)
        List<Opportunity> opportunities =
            [SELECT Amount, (SELECT UnitPrice FROM OpportunityLineItems)
             FROM Opportunity WHERE Id IN :opportunityIds];
        // Update Opportunities and Lines (if present)
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<OpportunityLineItem> oppLinesToUpdate = new List<OpportunityLineItem>();
        Decimal factor = 1 - (discountPercentage==null ? 0 : discountPercentage / 100);
        for(Opportunity opportunity : opportunities) {
            // Apply to Opportunity Amount
            if(opportunity.OpportunityLineItems!=null && opportunity.OpportunityLineItems.size()>0) {
                for(OpportunityLineItem oppLineItem : opportunity.OpportunityLineItems) {
                    oppLineItem.UnitPrice = oppLineItem.UnitPrice * factor;
                    oppLinesToUpdate.add(oppLineItem);
                }
            } else {
                opportunity.Amount = opportunity.Amount * factor;
                oppsToUpdate.add(opportunity);
            }
        }
        // Update the database
        SavePoint sp = Database.setSavePoint();
        try {
            update oppLinesToUpdate;
            update oppsToUpdate;
        } catch (Exception e) {
            // Rollback
            Database.rollback(sp);
            // Throw exception on to caller
            throw e;
        }
    }
    public class OpportunityServiceException extends Exception {}
}

// If we apply the configuration design consideration described earlier, we can add an overloaded version of the above service with an Options parameter, which allows the caller to instruct the service to skip committing the work. Returning the discounted values allows the client to implement a preview of the discounts that would be applied.
public static List<Decimal> applyDiscounts(
     List<Id> opportunityIds, Decimal discountPercentage, Options config)

// The method signature in the full example above takes a list of IDs, which is also per the design considerations. However, only a single parameter for the discount was used. The assumption is that the same discount is applied to all opportunities.
// However, if allowing different discounts per opportunity is required, you can use a parameter class
public class OpportunityService {
    public class ApplyDiscountInfo {
        public Id OpportunityId;
        public Decimal DiscountPercentage;
    }
    public static void applyDiscounts(List<ApplyDiscountInfo> discInfos) {
      // Implementation...
    }
}

/*
- Everyone loves APIs! Exposing your service logic to external parties through an API into your application is a must to develop a strong ecosystem of innovation and partner integrations around your products.
- It’s also worth considering exposing your API for off-platform callers, such as mobile or IoT. One way to do this is via the REST protocol.
*/
@RestResource(urlMapping='/opportunity/*/applydiscount')
global with sharing class OpportunityApplyDiscountResource {
    @HttpPost
    global static void applyDiscount(Decimal discountPercentage) {
        // Parse context
        RestRequest req = RestContext.request;
        String[] uriParts = req.requestURI.split('/');
        Id opportunityId = uriParts[2];
        // Call the service
        OpportunitiesService.applyDiscounts(
            new Set<Id> { opportunityId }, discountPercentage);
    }
}

// The ID of the opportunity is taken from the URI, and the discount percentage is taken from the posted information. 
// As with the JavaScript Remoting example in the prior unit, exception handling is left to the caller. 
// The platform marshalls exceptions into the appropriate JSON or XML response.

/* Learn Unit of Work Principles
- The Unit of Work is a desgin pattern that reduces repetitive code when implementing transaction management and the coding overheads of adhering to DML bulkification through extensive use of maps and lists. 
- It's not a requirement for implementing a service layer, but it can help. 
- Unit of work pattern: "Maintains a list of objects affected by a business transaction and coordinates the writing out of changes and the resolution of concurrency problems."
- On the Salesforce platform this translates to the pattern handling the following use cases: 
    - Recording record updates, inserts, and deletes to implement a specific business requirement
    - Recording record relationships to make inserting child or related records easier with less coding
    - When asked to write (or commit) to the database, bulkifies all records captured
    - Wrapping DML performed in SavePoint, freeing the developer from implementing this each time for every service method that is written
- It’s good practice for the Service layer code to manage a transaction scope using the SavePoint facility and the try/catch semantics.
- Apex Open-source library that contains an implementation of Martin Fowler’s Unit of Work pattern. It is implemented through a single class, fflib_SObjectUnitOfWork
    - This class exposes methods to allow an instance of the fflib_SObjectUnitOfWork class to capture records that need to be created, updated, or deleted as the service code is executed via the register methods. 
    - In addition, the commitWork method encapsulates the SavePoint and try/catch convention.
- Updating the database with DML occurs only when the commitWork method is called. Therefore, the service code can call the register methods as often and as frequently as needed, even in loops. This approach allows the developer to focus on the business logic and not on code to manage multiple lists and maps.
- the Unit of Work scope is determined by the start and finish of your service method code. Only call the commitWork once in the scope of the service method.
- To include the Unit of Work in your service code methods, follow these steps.
    - Initialize a single Unit of Work and use it to scope all the work done by the service method.
    - Have the service layer logic register records with the Unit of Work when it executes.
    - Call the Unit of Work commitWork method to bulkify and execute the DML.
    - If you’re calling between services, pass the outer Unit of Work instance as a parameter via method overloading. Don’t create a new one. Because the Unit of Work is representing the transactional scope of the service method, aim for only one Unit of Work instance per method call.
- To use the Unit of Work class, you need to construct it with a list of the objects that your code is interacting with.
- The objects must be in dependency order to ensure that parent and child records registered are inserted by the commitWork method in the correct order. 
*/
fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType> { OpportunityLineItem.SObjectType, Opportunity.SObjectType  }
);

public static void applyDiscounts(Set<Id> opportunityIds, Decimal discountPercentage) {
    // Unit of Work
    fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
        new List<SObjectType> { OpportunityLineItem.SObjectType, Opportunity.SObjectType  }
    );
    // Validate parameters
    // ...
    // Query Opportunities and Lines
    // ...
    // Update Opportunities and Lines (if present)
    // ...
    for(Opportunity opportunity : opportunities) {
        // Apply to Opportunity Amount
        if(opportunity.OpportunityLineItems!=null && opportunity.OpportunityLineItems.size()>0) {
            for(OpportunityLineItem oppLineItem : opportunity.OpportunityLineItems) {
                oppLineItem.UnitPrice = oppLineItem.UnitPrice * factor;
                uow.registerDirty(oppLineItem);
            }
        } else {
            opportunity.Amount = opportunity.Amount * factor;
            uow.registerDirty(opportunity);
        }
    }
    // Commit Unit of Work
    uow.commitWork();
}

// Notice that the lists are gone and that the SavePoint doesn’t have try/catch boilerplate code around it because this is all handled by the fflib_SObjectUnitOfWork class.
// The fflib_SObjectUnitOfWork class aggregates DML operations and wraps them in a SavePoint when the commitWork method is called.
// In more complex code, with multiple depths and classes, you can choose to pass SObjectUnitOfWork (or use a static). The called code can continue to register its own database updates, knowing that the owner of the Unit of Work, in this case, the service layer, performs a single commit or rollback phase on its behalf.


/* Apply Unit of Work Principles in Apex
- look at a more complex scenario: creating an Opportunity and all the required dependent records from scratch. The following test setup code shows how this could be done without the Unit of Work.
*/
List<Opportunity> opps = new List<Opportunity>();
List<List<Product2>> productsByOpp = new List<List<Product2>>();
List<List<PricebookEntry>> pricebookEntriesByOpp = new List<List<PricebookEntry>>();
List<List<OpportunityLineItem>> oppLinesByOpp = new List<List<OpportunityLineItem>>();
for(Integer o=0; o<10; o++) {
    Opportunity opp = new Opportunity();
    opp.Name = 'Opportunity ' + o;
    opp.StageName = 'Open';
    opp.CloseDate = System.today();
    opps.add(opp);
    List<Product2> products = new List<Product2>();
    List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
    List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
    for(Integer i=0; i<o+1; i++) {
        Product2 product = new Product2();
        product.Name = opp.Name + ' : Product : ' + i;
        products.add(product);
        PricebookEntry pbe = new PricebookEntry();
        pbe.UnitPrice = 10;
        pbe.IsActive = true;
        pbe.UseStandardPrice = false;
        pbe.Pricebook2Id = Test.getStandardPricebookId();
        pricebookEntries.add(pbe);
        OpportunityLineItem oppLineItem = new OpportunityLineItem();
        oppLineItem.Quantity = 1;
        oppLineItem.TotalPrice = 10;
        oppLineItems.add(oppLineItem);
    }
    productsByOpp.add(products);
    pricebookEntriesByOpp.add(pricebookEntries);
    oppLinesByOpp.add(oppLineItems);
}
// Insert Opportunities
insert opps;
// Insert Products
List<Product2> allProducts = new List<Product2>();
for(List<Product2> products : productsByOpp) {
    allProducts.addAll(products);
}
insert allProducts;
// Insert Pricebooks
Integer oppIdx = 0;
List<PricebookEntry> allPricebookEntries = new List<PricebookEntry>();
for(List<PriceBookEntry> pricebookEntries : pricebookEntriesByOpp) {
    List<Product2> products = productsByOpp[oppIdx++];
    Integer lineIdx = 0;
    for(PricebookEntry pricebookEntry : pricebookEntries) {
        pricebookEntry.Product2Id = products[lineIdx++].Id;
    }
    allPricebookEntries.addAll(pricebookEntries);
}
insert allPricebookEntries;
// Insert Opportunity Lines
oppIdx = 0;
List<OpportunityLineItem> allOppLineItems = new List<OpportunityLineItem>();
for(List<OpportunityLineItem> oppLines : oppLinesByOpp) {
    List<PricebookEntry> pricebookEntries = pricebookEntriesByOpp[oppIdx];
    Integer lineIdx = 0;
    for(OpportunityLineItem oppLine : oppLines) {
        oppLine.OpportunityId = opps[oppIdx].Id;
        oppLine.PricebookEntryId = pricebookEntries[lineIdx++].Id;
    }
    allOppLineItems.addAll(oppLines);
    oppIdx++;
}
insert allOppLineItems;

// redo the above code using the Unit of Work pattern
// Create a Unit Of Work
fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
    new Schema.SObjectType[] {
        Product2.SObjectType,
        PricebookEntry.SObjectType,
        Opportunity.SObjectType,
        OpportunityLineItem.SObjectType
    }
);

// Do some work!
for(Integer o=0; o<10; o++) {
    Opportunity opp = new Opportunity();
    opp.Name = 'UoW Test Name ' + o;
    opp.StageName = 'Open';
    opp.CloseDate = System.today();
    uow.registerNew(opp);
    for(Integer i=0; i<o+1; i++) {
      Product2 product = new Product2();
      product.Name = opp.Name + ' : Product : ' + i;
      uow.registerNew(product);
      PricebookEntry pbe = new PricebookEntry();
      pbe.UnitPrice = 10;
      pbe.IsActive = true;
      pbe.UseStandardPrice = false;
      pbe.Pricebook2Id = Test.getStandardPricebookId();
      uow.registerNew(pbe, PricebookEntry.Product2Id, product);
      OpportunityLineItem oppLineItem = new OpportunityLineItem();
      oppLineItem.Quantity = 1;
      oppLineItem.TotalPrice = 10;
      uow.registerRelationship(oppLineItem, OpportunityLineItem.PricebookEntryId, pbe);
      uow.registerNew(oppLineItem, OpportunityLineItem.OpportunityId, opp);
    }
}

// // Commit the work to the database!
uow.commitWork();

