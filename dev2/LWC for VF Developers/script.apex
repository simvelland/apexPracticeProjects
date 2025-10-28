/*
- VF is a server-side templating language. When the client (browser) requests a VF page, the server renders it, and sends it to the client as HTML. 
- When the UI needs to change (in response to a link click on the page, for example), the client requests a newly rendered page from the server. The server processes the UI change and sends the full page back to the client.
- In lwc, the client does most of the heavy lifting. o render a Lightning web component, it requests the component files from the server, processes the files to generate the appropriate markup, and then renders the component UI.
- Because the client can handle logic, sometimes it performs UI changes without a full callback to the server. It calls the server only when needed, such as when the component needs new data. Even then, the client requests the minimum amount of data needed.
- In Visualforce, properties are defined in an Apex controller (an Apex class file) and referenced in the page markup (the Visualforce page)
- In Lightning web components, properties are defined in the component’s JavaScript file and referenced in the page markup (the component’s HTML file)
- A getter executes logic when a property is read. 
- A setter executes logic when a property is written to
- The Standard Component Reference in the Visualforce Developer Guide is a library of standard Visualforce components.
- Similarly, the Lightning Developer Guide Component Reference is a library of base (standard) Lightning components.
- In Visualforce, you use tags such as <apex:component> and <apex:include> to implement composition.
- When a Visualforce page includes a Visualforce component, passing information down to the component is easy with the <apex:attribute> tag. 
- Passing information back up to the page, however, involves more complex patterns, such as hierarchies of Apex controllers.
- Composition in Lightning web components is similar. A parent Lightning web component can include a child component and communicate with it. 
- The composition and communication mechanisms are streamlined, so that every component’s logic is correctly encapsulated and loosely coupled with other components.
- To include a child component within a parent component, instantiate the component using the child component name in kebab case (yes, it looks like a kebab), preceded by its namespace. The default namespace for custom components is c. Base components use the lightning namespace.
- Visualforce pages that retrieve or modify data use a standard controller or an Apex controller. Traditionally, the client invokes controller methods when the page loads or as actions. After a method runs, the Visualforce engine generates the final markup and sends it to the client.
- Lightning web components that retrieve or modify data use Lightning Data Service or Apex methods. The client uses JavaScript to call Lightning Data Service or an Apex method. After Lightning Data Service or an Apex method runs, the Lightning Web Components engine returns the minimal needed data to the client. JavaScript on the client processes the data and generates the final markup.
- Lightning Data Service is the preferred (and easiest) way to work with Salesforce data in Lightning web components. Lightning Data Service is a similar concept to a Visualforce standard controller. Use Lightning Data Service in JavaScript to read, create, or modify single records, or to read some metadata, without writing Apex code.
- Lightning Data Service provides advanced capabilities such as caching and synchronization among components.
- Visualforce uses the view state to maintain state between server requests. The view state recreates the page and passes the state to different pages in wizards and guided workflows
- In Lightning web components, server requests are stateless. This has important implications for how you write Apex calls. Every time you make an Apex call, you must pass all the information that the method needs, and the method must return all the information that the component needs.
- In Visualforce, to reference an Apex method in the component markup, you bind an Apex controller to the Visualforce page by specifying it as an attribute in the <apex:page> tag
- In Lightning Web Components, instead of binding the controller and referencing the Apex methods in the page, we import the methods into the JavaScript file and then invoke the methods in JavaScript.
- There are two ways to interact with Apex methods from Lightning web components: Either wire the method or call the method imperatively.
- Wiring a method delegates control to the Lightning Web Components engine and creates a reactive service. 
- Calling Apex imperatively results in a one-time invocation
- In Visualforce, accessing a record Id within an Apex controller is pretty simple. Using a standard controller, you retrieve the record Id from the ApexPages.StandardController object.
- In Lightning web components, accessing a record Id in Apex is a little less straightforward. To access a record Id:
    Expose the component so that it’s available on record pages.
    In JavaScript, declare recordId as a public property. The parent component (the record Flexipage) populates the value of the recordId property.
    Pass the recordId as a parameter in Apex method calls.
- Lightning Experience uses secure data caching in the browser to improve page performance by avoiding additional round trips to the server. While this is helpful and recommended in production environments, disable caching during development to see the effect of any code changes without needing to empty the cache or wait for the cache to expire.
    From Setup, enter session in the Quick Find box, then click Session Settings.
    Deselect the checkbox: Enable secure and persistent browser caching to improve performance.
    Click Save.
- Visualforce pages often use the URLFOR function with <apex:commandButton> and <apex:commandLink> tags to navigate to pages inside or outside of Salesforce. Apex controller methods also facilitate navigation by returning PageReferences. 
- The preferred way to navigate programmatically from a Lightning web component to anywhere else is to use the Lightning Navigation Service. The service allows you to generate URLs, navigate to a page reference, work with URL parameters, and open files. Many page reference types, such as App, Lightning Component, Navigation Item (tab), and Record Page are supported.
- The Navigation Service eliminates hardcoded URLs by using meaningful PageReference objects to perform navigation. If Salesforce changes a specific URL, code that links to it doesn't break.
- To use the Navigation Service:
    Import the lightning/navigation JavaScript module into the Lightning web component.
    Make the Lightning web component’s class extend NavigationMixin.
    Call the Navigate method, passing the page reference of the page you want to navigate to.
*/
import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
export default class ClientSideNavigation extends NavigationMixin(LightningElement) {
    handleButtonClick() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Contact',
                actionName: 'list'
            }
        });
    }
}

/*
- Visualforce pages are supported in many low-code tools, including Lightning pages, the Utility bar, and Quick Actions.
- Visualforce and Lightning web components can also coexist on the same page and interact.
- Use the Lightning Components for Visualforce JavaScript Library when you want to include a Lightning web component in a specific location on a Visualforce page. This technique uses an iframe and gives you tools to communicate between the component and the Visualforce page.
- Lightning Components for Visualforce works for both Aura components and Lightning web components.
- Use Lightning Message Service to facilitate communication among Lightning components and Visualforce pages in different hierarchies of the DOM. 
*/