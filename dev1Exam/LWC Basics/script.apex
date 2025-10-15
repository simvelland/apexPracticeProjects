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
*/ 

