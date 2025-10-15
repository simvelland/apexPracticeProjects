/* LWC
- HTML provides the structure for your component
- JS defines the core business logic and event handling
- CSS provides the look, feel, and animation for your component
- You can use lwc:if and lwc:else conditional directives within your template to determine which visual elements are rendered
- all Lightning web components have a namespace that's sepertated from the folder name by a hyphen. For example, the markup for the LWC with the folder name app in the default namespace c is <c-app>
- LWCs uses modules to bundle core functionality and make it accessible to the JS in your component file. The core module for LWCs is lwc. 
- LightningElement is the base class for LWCs
- LWCs provides methods that allow you to "hook" your code up to critical events in a component's lifecycle. These events include when a component is: created, added to the DOM, rendered in a browser, enountering errors, removed from the DOM. Respond to any of these lifecycle events using callback methods. 
- Decorators are often used in JS to modify the behavior of a property or function. A single property or function can only have one decorator. 
    - @api marks a field as public. Public properties define the API for a component. 
    - @track tells the framework to observe changes to the properties of an object or to the elements of an array. If a change occeurs, the framework rerenders the component. All fields are reactive. Use @track only if a field contains an object or an array and if you want the framework to observe changes to the properties of the object or to the elements of an array. 
    - @wire gives you an easy way to get and bind data from a salesforce org

- Just as you nest HTML elements inside each other, Lightning web components- which are custom HTML elements- can be nested inside other lightning web components.
- Information can be passed up using events and event listeners. The child component dispatches the event and the parent compoenent listens for it. 
- Dispatching the event includes creating an event object the child can pass to the parent component. The parent has a handler to respond to the event. 
- Information can be passed down using public properties and public methods; you can make a component property public by prefacing it with the @api decorator. Then, set the public property by an external component.
- also, you can use getters and setters to execute some logic when properties are get or set. 
- LWCs encapsulates components, keeping them seperate from the global DOM. We can do this through a mechanism called Shadow DOM. Shadow DOM is a common implementation that allows a component's elements to live in a "sub tree" of the DOM. The component can keep its appearence and behavior within other apps or as a child of another component. 
- Salesforce Lightning Design System (SLDS) is a CSS framework that provides a look and feel that's consisten with Lightning Experience. LWCs that live in Lightning Experience or in the Salesforce mobile app can use SLDS without any import statements or static resources. 
- LWCs use a reactive wire service, which is built on Lightning Data Service. The wire service delivers a stream of data.
- adapterId (Identifier)—The identifier of the wire adapter.
*/
import { adapterId } from 'adapter-module';
@wire(adapterId, adapterConfig) propertyOrFunction;
/*
- adapter-module (String)—The identifier of the module that contains the wire adapter function.
- adapterConfig (Object)—A configuration object specific to the wire adapter.
- propertyOrFunction—A private property or function that receives the stream of data from the wire service. If a property is decorated with @wire, the results are returned to the property's data property or error property. If a function is decorated with @wire, the results are returned in an object with a data property and an error property.

*/ 

