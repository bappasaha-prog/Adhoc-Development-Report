Report Execution Log Parser

This Python script processes scheduler log files (eWebReportsScheduler.log and its rotated versions) to extract report execution details.
It identifies when each report started, when it ended, and whether it successfully executed or is still running.
The extracted information is saved in a summary file (result.txt).

⚙️ How It Works

Inputs Required

The base folder path where the log files are stored.

The full output file path where result.txt will be saved.

Log Files Checked
The script scans for these log files in the given directory:

eWebReportsScheduler.log
eWebReportsScheduler.log.1
eWebReportsScheduler.log.2
...
eWebReportsScheduler.log.10


Patterns Detected
The script uses regular expressions to detect:

Start of report execution

YYYY-MM-DD HH:MM:SS ... Update report in queue: <ReportName> (Job ...)

End of report execution (two possible formats):

Format 1 →

YYYY-MM-DD HH:MM:SS ... ReportExecuteEnd ... Report name Path : <ReportName>

Format 2 →

YYYY-MM-DD HH:MM:SS ... Report '<ReportName>' completed with result: Success


Data Stored
For each report, the script records:

Start time

End time

Execution status (Executed if ended, otherwise Running)

Output
All extracted details are written to the given output file in this format:

Report: Sales_Report
  Start: 2025-09-10 08:22:15
  End:   2025-09-10 08:25:30
  Status: Executed

Report: Inventory_Check
  Start: 2025-09-10 09:05:42
  End:   N/A
  Status: Running

📝 Example

Input when running script:

Enter the base path of the log files (e.g., C:/logs): C:/logs
Enter the full path to save result.txt (e.g., C:/output/result.txt): C:/output/result.txt


Output file (C:/output/result.txt):

Report: Sales_Report
  Start: 2025-09-10 08:22:15
  End: 2025-09-10 08:25:30
  Status: Executed

Report: Inventory_Check
  Start: 2025-09-10 09:05:42
  End: N/A
  Status: Running

▶️ How to Run


Open a terminal/command prompt and run:

Enter paths when prompted.

✅ Features

Parses multiple rotated log files automatically.

Handles two different log formats for report completion.

Creates a clear execution summary for each report.

Lightweight and portable (only requires built-in os and re modules).