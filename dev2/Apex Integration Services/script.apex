/* 
- An Apex callout enables you to tightly integrate your Apex code with an external service. The callout makes a call to an external web service or sends an HTTP request from Apex code, and then receives the response.
- Apex callouts come in two flavors.
    Web service callouts to SOAP web services use XML, and typically require a WSDL document for code generation.
    HTTP callouts to services typically use REST with JSON.
- These two types of callouts are similar in terms of sending a request to a service and receiving a response. But while WSDL-based callouts apply to SOAP Web services, HTTP callouts can be used with any HTTP service, either SOAP or R

GET
Retrieve data identified by a URL.

POST
Create a resource or post data to the server.

DELETE
Delete a resource identified by a URL.

PUT
Create or replace the resource sent in the request body.

Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
request.setMethod('GET');
HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.
if(response.getStatusCode() == 200) {
    // Deserialize the JSON string into collections of primitive data types.
    Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    // Cast the values in the 'animals' key as a list
    List<Object> animals = (List<Object>) results.get('animals');
    System.debug('Received the following animals:');
    for(Object animal: animals) {
        System.debug(animal);
    }
}

Http http = new Http();
HttpRequest request = new HttpRequest();
request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
request.setMethod('POST');
request.setHeader('Content-Type', 'application/json;charset=UTF-8');
// Set the body as a JSON object
request.setBody('{"name":"mighty moose"}');
HttpResponse response = http.send(request);
// Parse the JSON response
if(response.getStatusCode() != 201) {
    System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
} else {
    System.debug(response.getBody());
}

Test Callouts:
    - Apex test methods don’t support callouts, and tests that perform callouts fail
    - the testing runtime allows you to “mock” the callout
    - Mock callouts allow you to specify the response to return in the test instead of actually calling the web service. You are essentially telling the runtime, “I know what this web service will return, so instead of calling it during testing, just return this data.”
    - Using mock callouts in your tests helps ensure that you attain adequate code coverage and that no lines of code are skipped due to callouts.
    - To test your callouts, use mock callouts by either implementing an interface or using static resources
    - The Test.setMock method informs the runtime that mock callouts are used in the test method.
        @isTest
        private class AnimalsCalloutsTest {
            @isTest static  void testGetCallout() {
                // Create the mock response based on a static resource
                StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
                mock.setStaticResource('GetAnimalResource');
                mock.setStatusCode(200);
                mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
                // Associate the callout with a mock response
                Test.setMock(HttpCalloutMock.class, mock);
                // Call method to test
                HttpResponse result = AnimalsCallouts.makeGetCallout();
                // Verify mock response is not null
                Assert.areNotEqual(null,result, 'The callout returned a null response.');
                // Verify status code
                Assert.areEqual(200,result.getStatusCode(), 'The status code is not 200.');
                // Verify content type
                Assert.areEqual('application/json;charset=UTF-8',
                result.getHeader('Content-Type'),
                'The content type value is not expected.');
                // Verify the array contains 3 items
                Map<String, Object> results = (Map<String, Object>)
                    JSON.deserializeUntyped(result.getBody());
                List<Object> animals = (List<Object>) results.get('animals');
                Assert.areEqual(3, animals.size(), 'The array should only contain 3 items.');
            }
        }

    - the HttpCalloutMock interface enables you to specify the response that’s sent in the respond method. Your test class instructs the Apex runtime to send this fake response by calling Test.setMock again. For the first argument, pass HttpCalloutMock.class. For the second argument, pass a new instance of AnimalsHttpCalloutMock, which is your interface implementation of HttpCalloutMock
        @isTest
        global class AnimalsHttpCalloutMock implements HttpCalloutMock {
            // Implement this interface method
            global HTTPResponse respond(HTTPRequest request) {
                // Create a fake response
                HttpResponse response = new HttpResponse();
                response.setHeader('Content-Type', 'application/json');
                response.setBody('{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}');
                response.setStatusCode(200);
                return response;
            }
        }

        @isTest
        static void testPostCallout() {
            // Set mock callout class
            Test.setMock(HttpCalloutMock.class, new AnimalsHttpCalloutMock());
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock.
            HttpResponse response = AnimalsCallouts.makePostCallout();
            // Verify that the response received contains fake values
            String contentType = response.getHeader('Content-Type');
            Assert.isTrue(contentType == 'application/json');
            String actualValue = response.getBody();
            System.debug(response.getBody());
            String expectedValue = '{"animals": ["majestic badger", "fluffy bunny", "scary bear", "chicken", "mighty moose"]}';
            Assert.areEqual(expectedValue, actualValue);
            Assert.areEqual(200, response.getStatusCode());
        }

*/

public class AnimalLocator {
    public static String getAnimalNameById(Integer id) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + id);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        String name = null; // Initialize to avoid returning undefined variable
        if (response.getStatusCode() == 200) {
            Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            name = (String) payload.get('name');
        }
        return name;
    }
}


@isTest
public class AnimalLocatorTest {
    @isTest
    static void testGetCallout() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String name = AnimalLocator.getAnimalNameById();
        System.assertEquals('majestic badger', name, 'Should return the name field');
    }
}

@isTest
global class AnimalLocatorMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        String idPart = request.getEndpoint().substringAfterLast('/');
        Integer idVal = Integer.valueOf(idPart);
        response.setBody('{"id": ' + idVal + ', "name": "majestic badger"}');
        response.setStatusCode(200);
        return response;
    }
}


/* 
Apex SOAP Callouts
- In addition to REST callouts, Apex can also make callouts to SOAP web services using XML
- WSDL2Apex automatically generates Apex classes from a WSDL document. You download the web service's WSDL file, and then you upload the WSDL and WSDL2Apex generates the Apex classes for you. 
- The Apex classes construct the SOAP XML, transmit the data, and parse the response XML into Apex objects
- Instead of developing the logic to construct and parse the XML of the web service messages, let the Apex classes generated by WSDL2Apex internally handle all that overhead
- All experienced Apex developers know that to deploy or package Apex code, at least 75% of that code must have test coverage. This coverage includes our classes generated by WSDL2Apex. You might have heard this before, but test methods don't support web service callouts, and tests that perform web service callouts fail.
- To prevent tests from failing and to increase code coverage, Apex provides a built-in WebServiceMock interface and the Test.setMock method. You can use this interface to receive fake responses in a test method, thereby providing the necessary test coverage.
- When you create an Apex class from a WSDL, the methods in the autogenerated class call WebServiceCallout.invoke, which performs the callout to the external service. When testing these methods, you can instruct the Apex runtime to generate a fake response whenever WebServiceCallout.invoke is called. To do so, implement the WebServiceMock interface and specify a fake response for the testing runtime to send.
- The generated Apex classes include stub and type classes for calling the third-party web service represented by the WSDL document. These classes allow you to call the external web service from Apex. For each generated class, a second class is created with the same name and the prefix Async.
*/
    Test.setMock(WebServiceMock.class, new MyWebServiceMockImpl());

    public class AwesomeCalculator {
        public static Double add(Double x, Double y) {
            calculatorServices.CalculatorImplPort calculator = new calculatorServices.CalculatorImplPort();
            return calculator.doAdd(x,y);
        }
    }

    @isTest
    global class CalculatorCalloutMock implements WebServiceMock {
        global void doInvoke(
                Object stub,
                Object request,
                Map<String, Object> response,
                String endpoint,
                String soapAction,
                String requestName,
                String responseNS,
                String responseName,
                String responseType) {
                // start - specify the response you want to send
                calculatorServices.doAddResponse response_x =
                    new calculatorServices.doAddResponse();
                response_x.return_x = 3.0;
                // end
                response.put('response_x', response_x);
        }
    }

    @isTest
    private class AwesomeCalculatorTest {
        @isTest static void testCallout() {
            // This causes a fake response to be generated
            Test.setMock(WebServiceMock.class, new CalculatorCalloutMock());
            // Call the method that invokes a callout
            Double x = 1.0;
            Double y = 2.0;
            Double result = AwesomeCalculator.add(x, y);
            // Verify that a fake result is returned
            Assert.areEqual(3.0, result);
        }
    }

/*  Apex Web Services

Expose Your Apex Class as a Web Service
- You can expose your Apex class methods as a REST or SOAP web service operation. By making your methods callable through the web, your external applications can integrate with Salesforce to perform all sorts of nifty operations.
- Making your Apex class available as a REST web service is straightforward. Define your class as global, and define methods as global static. Add annotations to the class and methods. 
*/  @RestResource(urlMapping='/Account/*')
    global with sharing class MyRestResource {
        @HttpGet
        global static Account getRecord() {
            // Add your code
        }
    }

/*
- the class is annotated with @RestResource(urlMapping='/Account/*'). The base endpoint for Apex REST is https://MyDomain.my.salesforce.com/services/apexrest/. 
- The URL mapping is case-sensitive and can contain a wildcard character (*).
- Making your Apex class available as a SOAP web service is as easy as with REST. Define your class as global. Add the webservice keyword and the static definition modifier to each method you want to expose. The webservice keyword provides global access to the method it is added to.
*/ 
global with sharing class MySOAPWebService {
    webservice static Account getRecord(String id) {
        // Add your code
    }
}

/*
- The external application can call your custom Apex methods as web service operations by consuming the class WSDL file. Generate this WSDL for your class from the class detail page, accessed from the Apex Classes page in Setup. You typically send the WSDL file to third-party developers (or use it yourself) to write integrations for your web service.
- versioning your API endpoints so that you can provide upgrades in functionality without breaking existing code. You could create two classes specifying URL mappings of /Cases/v1/* and /Cases/v2/* to implement this functionality.
*/

@RestResource(urlMapping='/Cases/*')
global with sharing class CaseManager {
    @HttpGet
    global static Case getCaseById() {
        RestRequest request = RestContext.request;
        // grab the caseId from the end of the URL
        String caseId = request.requestURI.substring(
          request.requestURI.lastIndexOf('/')+1);
        Case result =  [SELECT CaseNumber,Subject,Status,Origin,Priority
                        FROM Case
                        WHERE Id = :caseId];
        return result;
    }
    @HttpPost
    global static ID createCase(String subject, String status,
        String origin, String priority) {
        Case thisCase = new Case(
            Subject=subject,
            Status=status,
            Origin=origin,
            Priority=priority);
        insert thisCase;
        return thisCase.Id;
    }
    @HttpDelete
    global static void deleteCase() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        delete thisCase;
    }
    @HttpPut
    global static ID upsertCase(String subject, String status,
        String origin, String priority, String id) {
        Case thisCase = new Case(
                Id=id,
                Subject=subject,
                Status=status,
                Origin=origin,
                Priority=priority);
        // Match case by Id, if present.
        // Otherwise, create new case.
        upsert thisCase;
        // Return the case ID.
        return thisCase.Id;
    }
    @HttpPatch
    global static ID updateCaseFields() {
        RestRequest request = RestContext.request;
        String caseId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Case thisCase = [SELECT Id FROM Case WHERE Id = :caseId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisCase.put(fieldName, params.get(fieldName));
        }
        update thisCase;
        return thisCase.Id;
    }
}

/* 
- To invoke your REST service, you need to use a… REST client! You can use almost any REST client, such as your own API client, the cURL command-line tool, or the curl library for PHP. We'll use the Workbench tool as our REST client application.
- Apex REST supports two formats for representations of resources: JSON and XML. 
- JSON representations are passed by default in the body of a request or response, and the format is indicated by the Content-Type property in the HTTP header.
- Apex REST supports OAuth 2.0 and session authentication mechanisms. In simple terms, this means that we use industry standards to keep your application and data safe. 
- As an alternative to the PUT method, use the PATCH method to update record fields
- pass the fields as JSON name/value pairs in the request body. That way the method can accept an arbitrary number of parameters, and the parameters aren't fixed in the method's signature. Another advantage of this approach is that no field is accidentally cleared because of not being included in the JSON string.
- This method deserialize the JSON string from the request body into a map of name/value pairs and uses the sObject put method to set the fields.
- Testing your Apex REST class is similar to testing any other Apex class—just call the class methods by passing in parameter values and then verify the results. For methods that don't take parameters or that rely on information in the REST request, create a test REST request.
- To simulate a REST request, create a RestRequest in the test method, and then set properties on the request as follows. You can also add params that you “pass” in the request to simulate URI parameters.
*/
// Set up a test request
RestRequest request = new RestRequest();
// Set request properties
request.requestUri =
    'https://MyDomain.my.salesforce.com/services/apexrest/Cases/'
    + recordId;
request.httpMethod = 'GET';
// Set other properties, such as parameters
request.params.put('status', 'Working');
// more awesome code here....
// Finally, assign the request to RestContext if used
RestContext.request = request;

/*
- If the method you're testing accesses request values through RestContext, assign the request to RestContext to populate it (RestContext.request = request;). 
*/ 

@IsTest
private class CaseManagerTest {
    @isTest static void testGetCaseById() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://MyDomain.my.salesforce.com/services/apexrest/Cases/'
            + recordId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        // Call the method to test
        Case thisCase = CaseManager.getCaseById();
        // Verify results
        Assert.isTrue(thisCase != null);
        Assert.areEqual('Test record', thisCase.Subject);
    }
    @isTest static void testCreateCase() {
        // Call the method to test
        ID thisCaseId = CaseManager.createCase(
            'Ferocious chipmunk', 'New', 'Phone', 'Low');
        // Verify results
        Assert.isTrue(thisCaseId != null);
        Case thisCase = [SELECT Id,Subject FROM Case WHERE Id=:thisCaseId];
        Assert.isTrue(thisCase != null);
        Assert.areEqual(thisCase.Subject, 'Ferocious chipmunk');
    }
    @isTest static void testDeleteCase() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://MyDomain.my.salesforce.com/services/apexrest/Cases/'
            + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        CaseManager.deleteCase();
        // Verify record is deleted
        List<Case> cases = [SELECT Id FROM Case WHERE Id=:recordId];
        Assert.isTrue(cases.size() == 0);
    }
    @isTest static void testUpsertCase() {
        // 1. Insert new record
        ID case1Id = CaseManager.upsertCase(
                'Ferocious chipmunk', 'New', 'Phone', 'Low', null);
        // Verify new record was created
        Assert.isTrue(Case1Id != null);
        Case case1 = [SELECT Id,Subject FROM Case WHERE Id=:case1Id];
        Assert.isTrue(case1 != null);
        Assert.areEqual(case1.Subject, 'Ferocious chipmunk');
        // 2. Update status of existing record to Working
        ID case2Id = CaseManager.upsertCase(
                'Ferocious chipmunk', 'Working', 'Phone', 'Low', case1Id);
        // Verify record was updated
        Assert.areEqual(case1Id, case2Id);
        Case case2 = [SELECT Id,Status FROM Case WHERE Id=:case2Id];
        Assert.isTrue(case2 != null);
        Assert.areEqual(case2.Status, 'Working');
    }
    @isTest static void testUpdateCaseFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://MyDomain.my.salesforce.com/services/apexrest/Cases/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Working"}');
        RestContext.request = request;
        // Update status of existing record to Working
        ID thisCaseId = CaseManager.updateCaseFields();
        // Verify record was updated
        Assert.isTrue(thisCaseId != null);
        Case thisCase = [SELECT Id,Status FROM Case WHERE Id=:thisCaseId];
        Assert.isTrue(thisCase != null);
        Assert.areEqual(thisCase.Status, 'Working');
    }
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Case caseTest = new Case(
            Subject='Test record',
            Status='New',
            Origin='Phone',
            Priority='Medium');
        insert caseTest;
        return caseTest.Id;
    }
}

/*
Apex REST supports these data types for parameters and return values.
    Apex primitives (excluding Object and Blob).
    sObjects
    Lists or maps of Apex primitives or sObjects (only maps with String keys are supported).
    User-defined types that contain member variables of the types listed above.

- Apex REST methods can be used in managed and unmanaged packages. 
- When calling Apex REST methods that are contained in a managed package, you need to include the managed package namespace in the REST call URL.
- For example, if the class is contained in a managed package namespace called packageNamespace and the Apex REST methods use a URL mapping of /MyMethod/*, the URL used via REST to call these methods would be of the form https://MyDomain.my.salesforce.com/services/apexrest/packageNamespace/MyMethod/.
- Instead of using custom Apex code for REST and SOAP services, external applications can integrate with Salesforce by using Salesforce's REST and SOAP APIs. These APIs let you create, update, and delete records.
- However, the advantage of using Apex web services is that Apex methods can encapsulate complex logic. This logic is hidden from the consuming application.
- Also, the Apex class operations can be faster than making individual API calls, because fewer roundtrips are performed between the client and the Salesforce servers. With an Apex web service call, there is only one request sent, and all operations within the method are performed on the server.
