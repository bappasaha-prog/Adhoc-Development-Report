How it Works--?

User Inputs---

Base folder path → location where the scheduler log files are stored.

Session ID → the ID you want to filter logs for.

Output folder path → where the result file will be saved.

Log Scanning---

Recursively scans through the base folder and its subfolders.

Finds files named eWebReportsScheduler.log.

Filtering----

Reads each log line.

Collects only the lines containing the given Session ID.

Result File-----

Creates a new text file named:

<folder_name>_<session_id>_all_logs.txt


Example:
If logs are under ReportLogs and Session ID = 12345:

ReportLogs_12345_all_logs.txt

📊 Example
Input

Base folder: C:\ProgramData\ReportLogs

Session ID: 12345

Output folder: C:\Output

Output

File created:

C:\Output\ReportLogs_12345_all_logs.txt


Containing only log lines with 12345.

▶️ How to Run
🔹 Run as Python script

🔹 Run as EXE

Run it directly:

session_log_extractor.exe

Enter base folder, Session ID, and output folder when prompted.