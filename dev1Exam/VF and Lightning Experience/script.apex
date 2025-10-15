/* Where can you use VF in Lightning Experience
- Vf apps and custom tabs are all available from the App Launcher
- app navigation bar
- within a standard page layout
- as a component in Lightning App Builder
- Quick action
- Override standard button or links
- custom buttons or links
*/

/*
- The largest difference between VF in Lightning Experience and VF in SF classic is the enviironment it runs in. In SF Classic, VF owns the page, the request, the environment. VF is the application container. But in Lightning Experience, VF runs inside an iframe that's wrapped inside the larger Lightning Experience container. 
- This change to the execution context has a number of effects on the way VF pages can affect the overall SF application. 
- When your Visualforce page runs in Lightning Experience, it’s displayed inside an HTML iframe. An iframe creates an embedded browsing context that’s effectively a separate browser “window” from the main Lightning Experience browsing context. The iframe creates a boundary between the Visualforce page and its parent, the Lightning Experience application.
*/

/* Classic VF Navigation
- Action methods return a PageReference object with the details of where the user is to be nacigated to, and then the VF framework hadnles the details of sending the right response back to the user's browser. 
- as developers adopt Visualforce features such as Remote Objects and JavaScript remoting, more of their apps’ behavior migrates from the server side, where PageReference is the rule, to the browser and JavaScript, where there’s no such thing as a PageReference.
- Lightning Experience manages navigation using events. The navigation event framework is made available as a JavaScript utility object that provides a number of functions that make creating programmatic navigation straightforward.
- The sforce.one object is automatically added to Visualforce pages when they run in Lightning Experience. This object provides a number of functions that trigger navigation events when the functions are called. To use these functions, you can call them directly from your page’s JavaScript code, or you can attach calls as click (or other) handlers to elements on the page.
- The sforce.one object isn’t available in Salesforce Classic. Any code that uses it should test for the existence of sforce.one first.
- do not set window.location directly.
- The Visualforce iframe doesn’t have direct access to the window.location value, so you can’t set it. If your code depends on setting it, it’ll break. That is, actions that fire navigation by setting window.location will simply stop navigating to wherever you were expecting to go.
- if you bypass the navigation functions in sforce.one, your navigation events won’t be tracked in the Lightning Experience navigation stack. That stack provides useful features, like Back buttons that account for redirects and the like. A number of features in Lightning Experience (and especially in the Salesforce app) depend on that stack containing all navigation events. It’s worth making sure you use it correctly.
- The good news is, in Salesforce Classic, window.location is available. The bad news is, this limitation means you’ll have to add an ugly if block to your code. Consider wrapping your navigation functions in utility methods that deal with this complexity, so that your main navigation logic can be straightforward.
*/

/*
- Visualforce pages look the same whether they are running in Salesforce Classic or Lightning Experience, unless you rework them to adapt to the appropriate user interface context. Built-in Visualforce components that display user interface elements aren’t easily restyled to match the Lightning Experience look-and-feel.
- Visualforce components that produce HTML have pass-through style and styleClass attributes. These attributes allow you to use your own styles and style classes to control the look and feel of the resulting HTML. style allows you to set styles directly on a component, while styleClass lets you attach classes for styles defined elsewhere. 
*/

