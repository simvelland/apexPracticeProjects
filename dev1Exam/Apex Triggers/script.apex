// Triggers
- Use Apex triggers if performance and scale is important, if your logic is too complex for the point-and-click tools, or if you're executing CPPU-intensive operations
- The prevent saving records in a trigger, call the addError() method on the sObject in question. The addError() method throws a fatal error inside a trigger. 
- Calling addError() in a trigger causes the entire set of operations to roll back, except when bulk DML is called with partial success. 
- Apex allows you to make calls to and integrate your Apex code with external Web sefvices. Apex calls to external Web services are referred to as callouts. 
- To make a callout from a trigger, call a class method that executes asyynchronously. Such a method is called a future method. 

Challenge 1

trigger AccountAddressTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        if (acc.Match_Billing_Address__c) acc.ShippingPostalCode = acc.BillingPostalCode;
    }
}


// Bulk Apex Triggers
- Apex triggers are optimized to operate in bulk. 


Challenge 2

trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {

    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    List<Task> tasksToInsert = new List<Task>();

    for (Opportunity opp : Trigger.new) {
        if (opp.Stage == 'Closed Won') {
            tasksToInsert(new Task(
                Subject = 'Follow Up Test Task',
                WhatId = opp.Id
            ));
        }
    }

    insert tasksToInsert;
}