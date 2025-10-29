/* 
- There are two types of tests that are commonly performed for Salesforce applications: unit tests and end-to-end tests. Their differences are in their scope and purpose.
- Unit Testing
    - Unit testing focuses on testing small, discrete pieces of functionality in an application. 
    - To facilitate unit testing, build your application using small, testable units, instead of writing a single long Apex method or class. This means modularizing the code into discrete methods that can be tested independently.
    -  Likewise, rather than writing a single massive Lightning component for an application, modularize the features into smaller components that can be tested independently. 
    - hort, fast unit tests that are easy to run encourage developers to write and run them as part of their development and continuous integration process. This ensures bugs are identified and fixed sooner rather than later. 
- End-to-End Testing:
    - focus on testing an entire application or user journey
    - For web applications, this often involves testing in a browser to validate how the code and components on a page work together in a test environment, such as a sandbox or a scratch org.
    - End-to-end tests tend to be slower than unit tests because they cover more functionality of the application per test
    - End-to-end tests are also less reliable than unit tests because of the random inconsistencies of a live environment, such as network latency, caching, dependency on third-party systems, infrastructure issues, and so on. These inconsistencies can cause a test to pass one time and fail the next, known as a flapping test. 
    - Despite these drawbacks, end-to-end tests provide a valuable, more realistic validation of the application and its integration points than unit tests.
- Jest Testing Framework
    - We're taking a test-driven development (TDD) approach, where we'll write the Jest test before we write the component that it tests.
    - Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine
    - npm is a package manager for distributing reusable code modules. In the universe of Node.js and npm, these reusable code modules are known as Node modules
    - In Salesforce terminology, a Node module—reusable code that can be easily distributed to multiple projects—is similar to unlocked packages.
    - Node.js and npm are popular tools in a modern JavaScript developer's toolbox
    - Jest is a powerful tool with rich features for writing JavaScript tests.
    - Jest can collect code coverage information and supports mocking to help isolate tests from complex dependencies. 
    - Jest tests don't run in a browser or connect to an org, so they run fast.
    - Use Jest to write unit tests for all of your Lightning web components
    - To run Jest tests for Lightning web components, you need the @salesforce/sfdx-lwc-jest Node module in your Salesforce DX project.
    - npm has some great out-of-the-box script automation flexibility.
    -  To run all tests for a single component every time you save changes, change directories to the component directory and run the npm command below that utilizes sfdx-lwc-jest with the --watch parameter. 
*/

import { sum } from '../sum';
describe('sum()', () => {
  it('should add 1 and 2 returning 3', () => {
    expect(sum(1, 2)).toBe(3);
  });
});

/*
- Line 1 imports the exported sum function from the sum JavaScript file.
- Line 3 is the start of the Jest test suite. The describe function, or block, is a test suite and accepts two arguments. First is the description of the unit we are testing which is usually in the form of a noun. Second is a callback function that holds one or more tests. You can also nest describe test suites inside each other to create greater clarity.
- Line 4 is the test (it is an alias for test). The it function, or block, accepts two arguments as well. First is another description of what we are expecting, usually starting with a verb. Then a callback function that builds up the test and holds the assertions or expectations for the test.
- Line 5 is the expect statement asserting the success condition: that the sum function would add the two arguments, 1 and 2, and return 3. toBe is one of the many Jest matchers.
- Jest tests for a Lightning web component should test the behavior of a single component in isolation, with minimal dependencies on external components or services.
*/

import { createElement } from 'lwc';
import UnitTest from 'c/unitTest';
describe('c-unit-test', () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while(document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });
  it('displays unit status with default unitNumber', () => {
    const element = createElement('c-unit-test', {
      is: UnitTest
    });
    expect(element.unitNumber).toBe(5);
    // Add the element to the jsdom instance
    document.body.appendChild(element);
    // Verify displayed greeting
    const div = element.shadowRoot.querySelector('div');
    expect(div.textContent).toBe('Unit 5 alive!');
  });
});

/*
- Line 1 is new. It imports the createElement method from the lwc framework. It's only available in tests.
- Line 2 imports the UnitTest class from the component JavaScript controller.
- Line 3 starts the describe test suite block.
- Line 4 is a Jest cleanup method. afterEach() is one of Jest's setup and cleanup methods. afterEach() runs after each test in the describe block it is in. This afterEach() method resets the DOM at the end of the test. Jest isn't running a browser when tests run. Jest uses jsdom to provide an environment that behaves much like a browser's DOM or document. Each test file gets a single instance of jsdom, and changes aren't reset between tests inside the file. It's a best practice to clean up between tests so that a test's output doesn't affect any other test. There are other setup and cleanup methods available. Check the Resources.
- Line 10 starts the it test block.
- Line 11 is where you use the imported createElement method. It creates an instance of the component and assigns it to the constant element.
- Line 14 has the expect asserting the unitNumber variable is set to 5. This is the first requirement that we are testing for, that unitNumber is set to 5 first.
- Line 16 actually adds the element to the jsdom's version of document.body using the appendChild method. The call attaches the Lightning web component to the DOM and renders it, which also means the lifecycle hooks connectedCallback() and renderedCallback() are called (more on these later).
- Line 18 uses querySelector (a standard DOM query method) to search the DOM for a div tag. Use element.shadowRoot as the parent for the query. It's a test-only API that lets you peek across the shadow boundary to inspect a component's shadow tree.
- Finally, line 19 has the expect looking at the textContent of the div tag to assert 'Unit 5 alive!' is there. This is the final requirement. Asserting the text is correct.

- When the state of a Lightning web component changes, the DOM updates asynchronously.
- To ensure that your test waits for updates to complete before evaluating the result, return a resolved Promise. To do this, chain the rest of your test code to the resolved Promise. Jest waits for the Promise chain to complete before ending the test. If the Promise ends in the rejected state, Jest fails the test.
*/
expect(div.textContent).not.toBe('Unit 6 alive!');
    // Return a promise to wait for any asynchronous DOM updates. Jest
    // will automatically wait for the Promise chain to complete before
    // ending the test and fail the test if the promise rejects.
    return Promise.resolve().then(() => {
      expect(div.textContent).toBe('Unit 6 alive!');
    });


it('displays unit status with input change event', () => {
    const element = createElement('c-unit-test', {
      is: UnitTest
    });
    document.body.appendChild(element);
    const div = element.shadowRoot.querySelector('div');
    // Trigger unit status input change
    const inputElement = element.shadowRoot.querySelector('lightning-input');
    inputElement.value = 7;
    inputElement.dispatchEvent(new CustomEvent('change'));
    return Promise.resolve().then(() => {
      expect(div.textContent).toBe('Unit 7 alive!');
    });
  });

/*
- The constant inputElement is set with a reference to a lightning-input field.
- Next, the value of that input field is set to 7.
- Then we use dispatchEvent to trigger an event with a CustomEvent using an event type of “change”.

- Lightning web components have a lifecycle managed by the framework. 
- The framework creates components, adds and removes them from the DOM, and renders DOM updates whenever the state of a component changes. 
- The connectedCallback() lifecycle hook fires when a component is inserted into the DOM
- The disconnectedCallback() lifecycle hook fires when a component is removed from the DOM. 
- One use for these hooks is to register and unregister event listeners.
*/


/*
- Lightning web components use a reactive wire service built on Lightning Data Service to read Salesforce data.
- Components use @wire in their JavaScript class to read data from one of the wire adapters in the lightning/ui*Api modules.
- The wire service is reactive in part because it supports reactive variables.
- Reactive variables are prefixed with a $
- When a reactive variable changes, the wire service provisions new data. If the data exists in the client cache, a network request may not be involved.
- Testing requires that you have full control over the input that your test consumes. No outside code or data dependencies are allowed. 
- We import the test utility API from sfdx-lwc-jest to mock the data so our test isn't dependent on unpredictable factors like remote invocation or server latency.
- There are three adapters for mocking wire service data.
    - Generic wire adapter: The generic adapter emits data on demand when you call the emit() API. It does not include any extra information about the data itself.
    - Lightning Data Service (LDS) wire adapter: The LDS adapter mimics Lightning Data Service behavior and includes information about the data's properties.
    - Apex wire adapter: The Apex wire adapter mimics calls to an Apex method and includes any error status.
*/

import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import ACCOUNT_NAME_FIELD from '@salesforce/schema/Account.Name';
  
export default class Record extends LightningElement {
  @api recordId;

  @wire(getRecord, { recordId: '$recordId', fields: [ACCOUNT_NAME_FIELD] })
  wiredRecord;
}

/*
- Line 8 is using the @wire decorator to access the imported getRecord method and passing in the reactive $recordId variable as its first argument. The second argument is a reference to the imported Account.Name from the schema on Line 3.
- Line 9 can be either a private property or a function that receives the stream of data from the wire service. If it's a property, the results are returned to the property's data property or error property. If it's a function, the results are returned in an object with a data property and an error property.
*/


/*
- The lightning-navigation service offers wire adapters and functions to generate a URL or navigate to a page reference.
*/

import { createElement } from 'lwc';
import WireCPR from 'c/wireCPR';
import { CurrentPageReference } from 'lightning/navigation';
// Mock realistic data
const mockCurrentPageReference = require('./data/CurrentPageReference.json');
describe('c-wire-c-p-r', () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });
  it('renders the current page reference in <pre> tag', () => {
    const element = createElement('c-wire-c-p-r', {
      is: WireCPR
    });
    document.body.appendChild(element);
    // Select element for validation
    const preElement = element.shadowRoot.querySelector('pre');
    expect(preElement).not.toBeNull();
    // Emit data from @wire
    CurrentPageReference.emit(mockCurrentPageReference);
    return Promise.resolve().then(() => {
      expect(preElement.textContent).toBe(
        JSON.stringify(mockCurrentPageReference, null, 2)
      );
    });
  });
});

/*
- Line 3 has a new import: CurrentPageReference.
- Line 5 grabs a file with mock PageReference data. We haven't created this yet so it is our first reason for the test to error.
- Line 21 is where we populate the mock data using emit().
- Line 22 starts the Promise that expects the mock data to be updated into the preElement.
*/

import { createElement } from 'lwc';
import WireLDS from 'c/wireLDS';
import { getRecord } from 'lightning/uiRecordApi';
// Mock realistic data
const mockGetRecord = require('./data/getRecord.json');
describe('c-wire-l-d-s', () => {
  afterEach(() => {
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });
  describe('getRecord @wire data', () => {
    it('renders contact details', () => {
      const element = createElement('c-wire-l-d-s', {
        is: WireLDS
      });
      document.body.appendChild(element);
      // Emit data from @wire
      getRecord.emit(mockGetRecord);
      return Promise.resolve().then(() => {
        // Select elements for validation
        const nameElement = element.shadowRoot.querySelector('p.accountName');
        expect(nameElement.textContent).toBe(
          'Account Name: ' + mockGetRecord.fields.Name.value
        );
        const industryElement = element.shadowRoot.querySelector('p.accountIndustry');
        expect(industryElement.textContent).toBe(
          'Industry: ' + mockGetRecord.fields.Industry.value
        );
        const phoneElement = element.shadowRoot.querySelector('p.accountPhone');
        expect(phoneElement.textContent).toBe(
          'Phone: ' + mockGetRecord.fields.Phone.value
        );
        const ownerElement = element.shadowRoot.querySelector('p.accountOwner');
        expect(ownerElement.textContent).toBe(
          'Owner: ' + mockGetRecord.fields.Owner.displayValue
        );
      });
    });
  });
});

/*
Line 3 has a new import: getRecord. getRecord is coming from the LDS API.
Line 5 is mocking the data again from the getRecord.json file in the data directory.
Line 19 uses the emit method on getRecord with the mockGetRecord as an argument.
Line 20 starts the Promise return and we check that various elements are updated with the mock data.
*/

/*
- The sfdx-lwc-jest package lets us run Jest on Lightning Web Components. It sets up all the necessary Jest configs to run tests without any additional changes
- This package includes a set of stubs (programs that simulate components that a module undergoing tests depends on) for all components in the Lightning namespace. 
- This includes all the Lightning Base Components. This allows us to run the tests in our environment while not in a Lightning environment. The stubs are installed in the src/lightning-stubs directory in the node-modules/@salesforce/sfdx-lwc-jest directory.
- There may be times when you need to override the default stubs provided. This is done by overriding the Jest configs and then creating custom stubs.
- 
