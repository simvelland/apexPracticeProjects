/* Org Development Model

- model that uses some different tools that provide 1) greater flexibility and scalability, 2) new ways to track and manage change, and 3) a different method of deployment.
- the org development model uses a source control repository to store changes and project files. A source repo can help to mitigate the pain point of keeping environments in sync. By externalizing the changes for each release, the team knows that the source repo reflects what they are delivering and isn’t affected by environment differences.
- Run the project generate manifest command and specify the components to be deployed, such as the new Language Course Instructor custom object and the other changes in his change list: The command generates the manifest file called package.xml in the current directory.
- Then, sf project deploy start --manifest package.xml --target-org dev-pro-sandbox
*/

