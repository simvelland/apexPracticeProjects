/*
- Apex test data is transient and isn't committed to the database
- By default, Apex test methods (API version 24.0 and later) can’t access pre-existing org data such as standard objects, custom objects, and custom settings data. They can only access data that they create.
- However, objects that are used to manage your organization or metadata objects can still be accessed in your tests. These are some examples of such objects.
    User
    Profile
    Organization
    CronTrigger
    RecordType
    ApexClass
    ApexTrigger
    ApexComponent
    ApexPage
- Using the Test.loadData method, you can populate data in your test methods without having to write many lines of code.
- Common test utility classes are public test classes that contain reusable code for test data creation.
- Use test setup methods (methods that are annotated with @testSetup) to create test records once and then access them in every test method in the test class. Test setup methods can be time-saving when you need to create reference or prerequisite data for all test methods, or a common set of records that all test methods operate on.
*/