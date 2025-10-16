/* Developer Console

- an IDE where you can create, debug, and test apps in your org
- Apex is a strongly typed, object-oriented language that allows developers to execute flow and transaction-control statements on the Lightning Platform server, in conjunction with calls to the Lightning Platform APIs. 
- The handy Log Inspector exists to make it easier to view large logs! The Log Inspector uses log panel views to provide different perspectives of your code.
Stack Tree—Displays log entries within the hierarchy of their objects and their execution using a top-down tree view. For instance, if one class calls a second class, the second class is shown as the child of the first.
Execution Stack—Displays a bottom-up view of the selected item. It displays the log entry, followed by the operation that called it.
Execution Log—Displays every action that occurred during the execution of your code.
Source—Displays the contents of the source file, indicating the line of code being run when the selected log entry was generated.
Source List—Displays the context of the code being executed when the event was logged. For example, if you select the log entry generated when the faulty email address value was entered, the Source List shows execute_anonymous_apex.
Variables—Displays the variables and their assigned values that were in scope when the code that generated the selected log entry was run.
Execution Overview—Displays statistics for the code being executed, including the execution time and heap size.
- A perspective is a layout of grouped panels. For instance, the predefined Debug perspective displays the Execution Log, Source, and Variables, while the Analysis perspective displays the Stack Tree, Execution Log, Execution Stack, and Execution Overview.
- You can choose a perspective by selecting Debug | Switch Perspectives or Debug | Perspective Manager. Yes, it’s as easy as switching between different communication panels—and much easier than trying to decipher logs from your Mission Specialist, Earth Space Station, and Mars Mission Control all in the same view.
- A log category is the type of information that is being logged. Here are two common log categories:
- ApexCode, which logs events related to Apex code and includes information about the start and end of an Apex method.
- Database, which includes logs related to database events, including Database Manipulation Language (DML), SOSL, and SOQL queries (something we get into later).
- In checkpoint inspector: 
    - Heap—Displays all objects present in memory at the line of code where your checkpoint was executed.
    - Symbols—Displays all symbols in memory in tree view.
    - 