/* Visualforce
- web development framework that enables developers to build sophisticated, custom user interfaces for mopile and desktop apps that can be hosted on the lightning platform.
- Visualforce uses a tag-based markup language that’s similar to HTML. Each Visualforce tag corresponds to a coarse or fine-grained user interface component, such as a section of a page, a list view, or an individual field
- Visualforce markup can be freely mixed with HTML markup, CSS styles, and JavaScript libraries, giving you considerable flexibility in how you implement your app’s user interface.
*/

Challenge 1

<apex:page showHeader="false" sidebar="false">
    <apex:image url="https://developer.salesforce.com/files/salesforce-developer-network-logo.png"
                alt="Salesforce Developer Network Logo"/>
</apex:page>


/* Simple Variables and Formulas
- VF pages can display data retrieved from the database or web services, data that changes depending on who is logged on and viewing the page, and so on. 
- The dynamic data is accessed in markup through the use of global variables, calculations, and properties made available by the page's controller. 
- Use expressions for dynamic output or passing values into components by assigning them to attributes
- A VF expression is any set of literal values, variables, sub-expressions, or operators that can be resolved to a single value. Method calls aren't allowed in expressions. 
- The expression syntax in Visualforce is: {! expression } 
- Anything inside the {! } delimiters is evaluated and dynamically replaced when the page is rendered or when the value is used. Whitespace is ignored.
- The resulting value can be a primitive (integer, string, and so on), a Boolean, an sObject, a controller method such as an action method, and other useful results. 
- Use global variables to access and display system values and resources in your VF markup.
- Use conditional expressions to display different information based on the value of the expression
*/ 

Challenge 2

<apex:page>
    <apex:pageBlock>
        <apex:pageBlockSection>
            {!$User.FirstName}
        </apex:pageBlockSection>
    </apex:pageBlock>
</apex:page>

/* Use Standard Controllers
- VF uses the traditional mvc paradigm, and includes sophisticated built-in controllers to handle standard actions and data access, providing simple and tight integration with the Lightning Platform database. 
- Most standard and all custom objects have standard controllers that can be used to interact with the data associated with the object, so you don't need to write the code for the controller yourself. 
- You can extend the standard controllers to add new functionality, or create custom controllers from scratch. 
- Visualforce pages that you want to embed within an object’s page layouts, use as object-specific custom actions, or use as mobile cards in the Salesforce app must use the standard controller for the relevant object.
*/ 

Challenge 3

<apex:page standardController="Contact">
    <apex:pageBlock>
        <apex:pageBlockSection>
            First Name: {! Contact.FirstName } <br/>
            Last Name: {! Contact.LastName } <br/>
            Owner's Email: {! Contact.Owner.Email } <br/>
        </apex:pageBlockSection>
    </apex:pageBlock>
</apex:page>


/* Display Records, Fields, and Tables
- Coarse-grained components provide a significant amount of functionality in a single components, and might add a lot of information and user interface to the page it's used on
- Fine-grained components provide more focused functionality, and enable you to design the page to look and behave the way you want.
- Use output components with a standard controller to make it easy to access and display record details. 
- USe higher level components when they offer the functionality you need, and use lower level coponents when you need more control over what's displayed on the page. 
*/ 

Challenge 4

<apex:page standardController="Opportunity">
    <apex:pageBlock>
        <apex:pageBlockSection>
            <apex:outputField label="Oppotunity Name" value="{! Opportunity.Name }"/>
            <apex:outputField label="Amount" value="{! Opportunity.Amount }"/>
            <apex:outputField label="Close Date" value="{! Opportunity.CloseDate }"/>
            <apex:outputField label="Account Name" value="{! Opportunity.Account.Name }"/>
        </apex:pageBlockSection>
    </apex:pageBlock>
</apex:page>


/* Input Data Using Forms
- <apex:form> is a VF component that packages everything inside it into something that can be sent back to the server as part of a page action. 
*/

Challenge 5

<apex:page standardController="Contact">
    <apex:form>
        <apex:pageBlock>
            <apex:pageBlockSection>
                <apex:inputField value="{! Contact.FirstName }" />
                <apex:inputField value="{! Contact.LastName }" />
                <apex:inputField value="{! Contact.Email }" />
            </apex:pageBlockSection>
            <apex:pageBlockButtons>
                <apex:commandButton action="{! save }" value="Save"/>
            </apex:pageBlockButtons>
        </apex:pageBlock>
    </apex:form>
</apex:page>
