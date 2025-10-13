// Flow Types

Three general types of flows:
- Screen Flow
    - launched by: quick action, lightning page, experience cloud site, and more.
    - screen flows provide a UI that guides users through a business process 
- Autolaunched Flow
    - launched by: another flow, apex code, REST API 
    - Autolaunched flows automate business processes that have no UI. They have no trigger and they run in the background. 
- Triggered Flow
    - launched by: time, data change, platform event 
    - Triggered flows are autolaunched by a trigger you specify. They run in the background. 

- There are three types of triggers:
    - Schedule
    - Platform Event 
    - Record 

- Fast field update; runs during the record update that triggered the flow and before that update is saved. use it for updating the record that triggered the transaction, showing a custom error to users. the benefit is optimal performance because the database is minimally affected. 
- Related Records and Actions; runs during the record update that triggered the flow and after that update is saved; use it to create, update, or delete other records, calling subflows, calling actions, such as send email alert or post to chatter; 
- Run asynchronously; runs immediately after the record update that triggered the flow is complete; use it to execute more advanced scenarios like sending requests to external systems or performing other longer running processes.
- Scheduled paths: runs in the future, after the trigger has fired, based on dates and times; use it to schedule reminders or follow-ups based on dates in the records that triggered the flow, such as Close Date 

// Adding a Scheduled Task to Flow; objective is to create a scheduled path to run a record-triggered flow at a specified time

- You can delay the automation of a record-triggered flow by using a scheduled path 
- Actions on a scheduled path are triggered when the specified record change occurs, but run after a period of time 
- They can also be scheduled for a period of time before or after a field on the triggering record. For example:
    6 hours after a case is created
    2 days after the renewal date for an account
    1 month before the warranty expiration date
- Set the org's Default Workflow User so that Salesforce knows which user should run the flow's scheduled path. 

// Flow Trigger Explorer
- With Flow Trigger Explorer, you can select an object to see all of the associated flows that run when a record is created, updated, or deleted, and change the order in which those flows run. 
- This interface allows for easy navigation and ordering of all the flows that run under the same circumstances. 
- You can also view individual flow details and manage versions
- access information about objects and automations
- change the order in which record-triggered flows run
- The Time-Based Automations screen shows you individual instances of the flow so you can monitor pending automation. 