Working of the Script

This script automates the creation of multiple folders under C:\ProgramData\ReportLogs using folder names listed in a text file (Foldername.txt).

Step-by-Step Process

Reads Folder Names

Opens c:\Foldername.txt.

Reads each line (each line should contain a folder name).

Ignores empty lines or lines with only spaces.

Creates Folders

For each folder name, creates a new directory inside:

C:\ProgramData\ReportLogs\<FolderName>


Uses os.makedirs(..., exist_ok=True) → prevents errors if the folder already exists.

Error Handling

If Foldername.txt does not exist → prints error.

If a folder cannot be created → prints error with reason.

Output

For each folder successfully created, prints:

Folder created: C:\ProgramData\ReportLogs\ClientA

README (Usage Guide)
Purpose

This script creates multiple folders under C:\ProgramData\ReportLogs based on folder names provided in a text file (c:\Foldername.txt).

Prerequisites

A text file named Foldername.txt located in C:\.

Write access to C:\ProgramData\ReportLogs.

Preparing the Foldername.txt File

Example c:\Foldername.txt:

ClientA
ClientB
ClientC


Each line = one folder name.

How to Run the Script

Save the script as create_folders.py.

Open Command Prompt (with Administrator rights if needed).

Run:

python create_folders.py

Example Output
Folder created: C:\ProgramData\ReportLogs\ClientA
Folder created: C:\ProgramData\ReportLogs\ClientB
Folder created: C:\ProgramData\ReportLogs\ClientC


If a folder already exists:

Folder created: C:\ProgramData\ReportLogs\ClientA

(no error, since exist_ok=True ignores duplicates).

Error Messages

If Foldername.txt is missing:

The file c:\Foldername.txt does not exist.


If folder creation fails (e.g., permission issues):

Error creating folder C:\ProgramData\ReportLogs\ClientA: [Permission Denied]