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


