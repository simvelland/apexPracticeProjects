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

