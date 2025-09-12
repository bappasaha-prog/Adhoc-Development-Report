What it does

This script reads scheduler log files (eWebReportsScheduler.log and its rotated versions .1 … .10), extracts key events, and saves them in a clean summary file called result.txt.
How it works--??

Looks for these events inside logs:

LoadXml → when a job XML is loaded.

Execute → when a job starts running.

ReportExecuteStart → when a report starts executing.

Groups events by the job XML name found in LoadXml.

Saves everything in result.txt in the same folder.

Example
Log input:
2025-09-08 10:11:12,345 [Api.Scheduler.SchedulerJob.LoadXml] Job123.xml
2025-09-08 10:11:15,678 [Api.Scheduler.SchedulerJob.Execute] Job123 execution started
2025-09-08 10:11:20,901 [Api.Execute.ExecuteReport.Process] ReportExecuteStart: SalesReport

Result output:
Group: Job123.xml
[LoadXml] 2025-09-08 10:11:12,345 - Job123.xml
[Execute] 2025-09-08 10:11:15,678 - Job123 execution started
[ReportExecuteStart] 2025-09-08 10:11:20,901 - SalesReport

How to run--

Run it in terminal:

Enter the folder path where your log files are stored.

After running, check result.txt in the same folder.