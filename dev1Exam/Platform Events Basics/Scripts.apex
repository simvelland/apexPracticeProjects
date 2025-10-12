// Publishing Event Messages Using Apex

Cloud_News__e newsEvent = new Cloud_News__e(
    Location__c = 'Mountain City',
    Urgent__c = true,
    News_Content__c= 'Lake Road closed due to mudslides.'
);

Database.SaveResult sr = EventBus.publish(newsEvent);

if (sr.isSuccess()) {
    System.debug('Event successfully published.');
} else {
    for (Database.Error err: sr.getErrors()) {
        System.debug('Error returned: ' + 
        err.getStatusCode() + '-' + err.getMessage());
    }
}

// Publishing multiple events in the same call

List<Cloud_News__e> newsEventList = new List<Cloud_News__e>();

Cloud_News__e event1 = new Cloud_News__e(
    Location__c='Mountain City',
    Urgent__c=true,
    News_Content__c='Lake Road is closed due to mudslides.'
);

Cloud_News__e event2 = new Cloud_News__e(
    Location__c='Mountain City',
    Urgent__c=false,
    News_Content__c='Small incident on Goat Lane causing traffic.'
);

newsEventList.add(event1);
newsEventList.add(event2);

List<Database.SaveResult> results = EventBus.publish(newsEventList);

for (Database.SaveResult sr : results) {
    if (sr.isSuccess()) {
        System.debug('Successfully published event.');
    } else {
        for(Database.Error err : sr.getErrors()) {
            System.debug('Error returned: ' +
                        err.getStatusCode() +
                        ' - ' +
                        err.getMessage());
        }
    }
}

/* Note: Events are published asynchronously when system resources become available. After being published, they are stored in the event bus for a specific retention period. To get final confirmation of the final event publishing result, use Apex Publish Callbacks.  */

/* The Salesforce Platform provides allocations for how many events you can define in your org, and how many events you can publish in an hour. For events configured with the Publish After Commit behavior, each method execution is counted as one DML statement against the Apex DML statement limit.

You can check limit usage using the Apex Limits.getDMLStatements()
method. For events configured with the Publish Immediately behavior, each method execution is counted against a separate event publishing limit of 150 EventBus.publish() calls. You can check limit usage using the Apex Limits.getPublishImmediateDML() method. For more information see the Resources section.  */

To publish without apex code, use record creation functionality in Flow Builder. 

To publish event messages using Salesforce APIs, use Pub/Sub API or SOAP/REST/Bulk API.

/* When using data APIs, you publish events in the same way that you insert sObjects. Like with Apex, the event message is published asynchronously. When you publish an event and get a success status of true, the publish request is queued in Salesforce. */

On the SF platform, you subscribe to events using Apex triggers, processes, flows, and empApi Lightning component. 
In an external app, you subscribe to events using Pub/Sub API. 

Platform events support only after insert triggers. The after insert trigger event corresponds to the time after a platform event is published. After an event message is published, the after insert trigger is fired.

Unlike triggers on standard or custom objects, triggers on platform events don’t execute in the same Apex transaction as the one that published the event. The trigger runs in its own process under the Automated Process entity, 
which is a system user. As a result, debug logs corresponding to the trigger execution are created by the Automated Process entity and aren’t available in the Developer Console. To collect platform event trigger logs, add a trace 
flag entry for the Automated Process entity in Setup

You can override the running user of a platform event trigger so that the trigger runs under that user instead of Automated Process. Configure the trigger by using PlatformEventSubscriberConfig in Metadata API or Tooling API

Lightning apps can use the empApi Lightning Web or Aura component to subscribe to events in the app
To use the empApi methods in your lightning web component, import the methods from the lightning/empApi module as such: import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';  Then, call the imported methods in your js code. 
To use the empApi methods in Aura components: <lightning:empApi aura:id="empApi"/>   Then, in the clieint-side controller, add functions to call the component methods. 

To subscribe to Platform Event Notifications declaritively, create a platform event-triggered flow. Alternatively, you can subscribe to a platform event in flows using a Pause element- that message causes a paused flow interview to resume.

Pub/Sub API provides a single interface for publiishing and subscribing to platform events. It efficiently publishes and delivers binary event messages in the Apache Avro format. 
Pub/Sub API uses a pull subscription model in which the client requests a number of events from the server based on its processing capacity. 