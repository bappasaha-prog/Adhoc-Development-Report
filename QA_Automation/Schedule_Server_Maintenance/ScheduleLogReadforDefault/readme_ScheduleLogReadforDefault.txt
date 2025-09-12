Working of the Script

This script analyzes scheduler log files to match report execution start and report execution end entries, then categorizes them into completed, in-progress, and orphan executions.

Step-by-Step Working

Takes Input from User

Asks for:

Base path where log files are stored.

Output file path where results will be saved (result.txt).

Defines Patterns (Regex)

Looks for lines like:

Start Pattern → ReportExecuteStart: Name: <ReportName>

End Pattern → ReportExecuteEnd: Name: <ReportName>

Also extracts the timestamp (yyyy-mm-dd HH:MM:SS) and report name.

Reads Log Files

Checks for these files inside the given folder:

eWebReportsScheduler.log
eWebReportsScheduler.log.1
eWebReportsScheduler.log.2
...
eWebReportsScheduler.log.10


Skips files that don’t exist.

Collects Entries

For each line:

If it’s a Start, adds to start_entries.

If it’s an End, adds to end_entries.

Stores the timestamp, report name, and full line text.

Matches Start and End Entries

For each Start entry:

Finds the first End entry with the same report name where the end time is after the start time.

If found → marks as Completed Execution and calculates execution duration (end - start).

If no matching End → report goes into In-Progress (WIP) list.

For End entries with no matching Start → goes into Orphan End list.

Writes to Result File

Creates an output file with 3 sections:

=== Completed Executions ===
StartLine | EndLine | ExecuteTime: 0:00:30

=== In-Progress (Start Found, End Missing) ===
<Start log line here>

=== Orphan End Entries (End Found, Start Missing) ===
<End log line here>


Error Handling

If a file can’t be read → prints warning.

If output file fails to write → prints error.

Final Output

The script helps you quickly identify:

Completed jobs with execution time.

Jobs that started but haven’t ended yet (possibly still running or stuck).

⚠️ Orphan ends (end found without start, could mean missing logs).

Open Command Prompt / Terminal

Press Win + R, type cmd, and hit Enter.

Navigate to the folder where you saved log_parser.py, for example:

cd C:\Users\YourName\Scripts

3. Run the Script

Use Python to run it:

python log_parser.py

4. Provide Inputs When Prompted

The script will ask you for 2 things:

Base path where logs are stored
Example:

C:\ProgramData\ReportLogs


Output file path where you want results
Example:

C:\ProgramData\ReportLogs\result.txt

Example Run
C:\Users\YourName\Scripts> python log_parser.py
Enter base path where log files are located: C:\ProgramData\ReportLogs
Enter full path for output result.txt file: C:\ProgramData\ReportLogs\result.txt
✅ Done! Output written to: C:\ProgramData\ReportLogs\result.txt

📂 Output File (result.txt)

The file will contain 3 sections:

=== Completed Executions ===
2025-09-11 10:05:00 ... ReportExecuteStart: Name: SalesReport,... | 
2025-09-11 10:05:30 ... ReportExecuteEnd: Name: SalesReport,... | 
ExecuteTime: 0:00:30

=== In-Progress (Start Found, End Missing) ===
2025-09-11 11:00:00 ... ReportExecuteStart: Name: InventoryReport,...

=== Orphan End Entries (End Found, Start Missing) ===
2025-09-11 09:55:00 ... ReportExecuteEnd: Name: BillingReport,...