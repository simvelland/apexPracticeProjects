/*
- Cache is temporary storage for frequently accessed data from a database. 
- Platfrom cache is a memory layer that stores Salesforce session and org data for later access
- Applications can quickly access this data; they don’t need to duplicate calculations and requests to the database on subsequent transactions. In short, think of Platform Cache as RAM for your cloud application.
- With Platform Cache, you can also allocate cache space so that some apps or operations don’t steal capacity from others. You use partitions to distribute space
- You can use Platform Cache in your code almost anywhere you access the same data over and over. Using cached data improves the performance of your app and is faster than performing SOQL queries repetitively, making multiple API calls, or computing complex calculations.
- Examples of such static data are:
    Public transit schedule
    Company shuttle bus schedule
    Tab headers that all users see
    A static navigation bar that appears on every page of your app
    A user’s shopping cart that you want to persist during a session
    Daily snapshots of exchange rates (rates fluctuate during a day)
- Values that are a result of complex calculations or long queries are good candidates for cache storage. Examples of such data are:
    Total sales over the past week
    Total volunteering hours company employees did as a whole
    Top sales ranking
- if your data is accessed by asynchronous Apex, it can’t be stored in a cache that is based on the user’s session.
- There are two types of Platform Cache: org cache and session cache.
    - Org Cache
        - Org cache stores org-wide data that anyone in the org can use
        - Org cache is accessible across sessions, requests, and org users and profiles.
    - Session Cache
        - Session cache stores data for an individual user and is tied to that user’s session. 
        - The maximum life of a session is 8 hours.
- Cache Partitions
    - Partitions let you allocate cache space to balance usage and performance across apps.
    - Caching data to designated partitions ensures that the cache space isn’t overwritten by other apps or by less critical data.
    - Each partition capacity is broken down between org cache and session cache.
    - Session and org cache allocations can be zero, 5 MB, or greater, and must be whole numbers
    - The minimum size of a partition, including its org and session cache allocations, is 5 MB.
    - For example, say that your org has a total of 10-MB cache space and you created a partition with a total of 5 MB, 5 MB of which is for session cache and 0 MB for org cache. Or you can create a partition of 10-MB space, with 5 MB for org cache and 5 MB for session cache. 
    - The sum of all partitions, including the default partition, equals the Platform Cache total allocation.
- To use Platform Cache, first set up at least one partition. Once you’ve set up partitions, you can add, access, and remove data from them using the Platform Cache Apex API.
- Each partition has one session cache and one org cache segment. You can allocate separate capacity to each segment. 
- Each cache key has the following format: Namespace.Partition.Key
- Namespace is the namespace name of the org where the app is running, which can also be set to the special name “local”. The “local” name refers to the namespace of your org whether a namespace is defined in the org or not.
- Partition is the name of the partition you created.
- Key is the name of the key you used to store a value. The key name uniquely represents your cached value.
- For example, this snippet stores a value in the org cache for the DollarToEuroRate key:
    Cache.Org.put('local.CurrencyCache.DollarToEuroRate', '0.91');
- Either use the Cache.Org class methods, or use the Cache.OrgPartition class to reference a specific partition. Then call the cache methods on that partition.
*/
// Get partition
Cache.OrgPartition orgPart = Cache.Org.getPartition('local.CurrencyCache');
// Add cache value to the partition. Usually, the value is obtained from a
// callout, but hardcoding it in this example for simplicity.
orgPart.put('DollarToEuroRate', '0.91');
// Retrieve cache value from the partition
String cachedRate = (String)orgPart.get('DollarToEuroRate');
/*
- If you’re managing cache values in just one partition, use the Cache.OrgPartition methods
- The Cache.OrgPartition methods are easier to use than the Cache.Org methods because you specify the namespace and partition prefix only once when you create the partition object.
- When the partition limit is exceeded, Salesforce evicts cached data based on a least recently used (LRU) algorithm
- The cache eviction takes place until usage is reduced to less than or equal to 100% capacity
- Also, if you exceed the local cache limit, items can be evicted from the local cache before the request has been committed.
- The amount of time during which data is kept in the cache is called the time-to-live value
- You specify the time-to-live value when you store a key-value pair in the cache using Apex methods.
- For session cache, your data can live up to 8 hours in the cache.
- For org cache, your data can live up to 48 hours in the cache
- By default, the time-to-live value for org cache is 24 hours.
- Session cache expires when its specified time-to-live value is reached or when the user session expires, whichever comes first. 
- As a best practice, your code should anticipate and accommodate points of failure. In other words, always assume that a cache miss can happen. 
- A cache miss is when you request a value for a key from the cache but the value is not found. The value that your get() call returns is null. 
*/
Cache.OrgPartition orgPart = Cache.Org.getPartition('local.CurrencyCache');
String cachedRate = (String)orgPart.get('DollarToEuroRate');
// Check the cache value that the get() call returned.
if (cachedRate != null) {
    // Display this exchange rate
} else {
    // We have a cache miss, so fetch the value from the source.
    // Call an API to get the exchange rate.
}

/*
- Use the Cache.Session and Cache.SessionPartition classes to access values stored in the session cache.
- To manage values in any partition, use the methods in the Cache.Session class. If you’re managing cache values in only one partition, use the Cache.SessionPartition methods instead.
- The Cache.SessionPartition methods are easier to use than the Cache.Session methods because you specify the namespace and partition prefix only once when you create the partition object.
*/
// Get partition
Cache.SessionPartition sessionPart = Cache.Session.getPartition('local.CurrencyCache');
// Add cache value to the partition
sessionPart.put('FavoriteCurrency', 'JPY');
// Retrieve cache value from the partition
String cachedRate = (String)sessionPart.get('FavoriteCurrency');

// - Access cached values stored in the platform cache from a Visualforce page by using the $Cache.Session or $Cache.Org global variables. By using these global variables, you can read cached values that were stored with Apex directly from your Visualforce page.
<apex:outputText value="{!$Cache.Session.ExPro.CurrencyCache.FavoriteCurrencyRate}"/>
// - Unlike with Apex methods, you can’t omit the namespace.partition prefix to reference the default partition in the org. 
<apex:outputText value="{!$Cache.Session.local.MyPartition.Key}"/>

// If the cached value is a data structure that has properties or methods, like an Apex List or a custom class, access those properties in the $Cache.Session expression using dot notation. For example, this markup invokes the List.size() Apex method if the value of numbersList is declared as a List.
<apex:outputText value="{!$Cache.Session.local.MyPartition.numbersList.size}"/>

// This example accesses the value property on the myData cache value that is declared as a custom class.
<apex:outputText value="{!$Cache.Session.local.MyPartition.myData.value}"/>

// Only Apex code running from your app’s namespace can access and use your namespace’s cache. No other code in the subscriber org can use this cache. 
// You can test your app against your namespace’s cache and be assured that the cache allocation is going to be protected in every subscriber org.
// Cache partitions are distributed to subscribers as part of the app’s package. 
// Add one or more cache partitions for your namespace to your package as components in the same way as you add other components. 
// Cache partitions aren’t automatically added as dependent components.

public class ExchangeRates {
    private String currencies = 'EUR,GBP,CAD,PLN,INR,AUD,SGD,CHF,MYR,JPY,CNY';
    public String getCurrencies() { return currencies;}
    public Exchange_Rate__c[] rates {get; set;}
    //
    // Checks if the data is old and gets new data from an external web service
    // through a callout. Calls getCachedRates() to manage the cache.
    //
    public void init() {
        // Let's query the latest data from Salesforce
        Exchange_Rate__c[] latestRecords = ([SELECT CreatedDate FROM Exchange_Rate__c
                        WHERE Base_Currency__c =:RateLib.baseCurrencies
                              AND forList__c = true
                        ORDER BY CreatedDate DESC
                        LIMIT 1]);
        // If what we have in Salesforce is old, get fresh data from the API
        if ( latestRecords == null
            || latestRecords.size() == 0
            || latestRecords[0].CreatedDate.date() < Datetime.now().date()) {
            // Do API request and parse value out
            String tempString = RateLib.getLoadRate(currencies);
            Map<String, String> apiStrings = RateLib.getParseValues(
                tempString, currencies);
            // Let's store the data in Salesforce
            RateLib.saveRates(apiStrings);
            // Remove the cache key so it gets refreshed in getCachedRates()
            Cache.Org.remove('Rates');
        }
        // Call method to manage the cache
        rates = getCachedRates();
    }
    //
    // Main method for managing the org cache.
    // - Returns exchange rates (Rates key) from the org cache.
    // - Checks for a cache miss.
    // - If there is a cache miss, returns exchange rates from Salesforce
    //    through a SOQL query, and updates the cached value.
    //
    public Exchange_Rate__c[] getCachedRates() {
        // Get the cached value for key named Rates
        Exchange_Rate__c[] rates = (Exchange_Rate__c[])Cache.Org.get(
            RateLib.cacheName+'Rates');
        // Is it a cache miss?
        if(rates == null) {
            // There was a cache miss so get the data via SOQL
            rates = [SELECT Id, Base_Currency__c, To_Currency__c, Rate__c
                        FROM Exchange_Rate__c
                        WHERE Base_Currency__c =:RateLib.baseCurrencies
                              AND forList__c = true
                              AND CreatedDate = TODAY];
            // Reload the cache
            Cache.Org.put(RateLib.cacheName+'Rates', rates);
        }
        return rates;
    }
}

/*
- If the data is stale or is not found, the init() method retrieves new exchange rates through an API call, and then stores them in Salesforce.
- The getCachedRates() method manages the cache internally. If the cached value is not found, this method retrieves an array of rates from Salesforce and stores it in the cache.
- Because our app uses external data, it fetches data from a web service through API calls. It also stores the data as Salesforce records as a backup for refreshing the cache.
- We recommend that you include all the logic for managing the cache in one method. That way, the cache is manipulated in only one place in your app. 
- The central management of the cache reduces the chance of errors from accessing invalid cache (cache misses) or accidentally overwriting cached values.
- Storing smaller pieces of data, like field values instead of entire sObjects, can reduce your cache usage size. 
- But if you store less data in each key, you might need complex logic to rebuild the data and sObjects, which requires more processing time. 
- And an sObject array stored in one key uses less cache space than the total size of individual sObjects stored in individual keys. 
- Caching smaller items instead of a list of items worsens cache performance because of the overhead of serialization and cache commit time. 
