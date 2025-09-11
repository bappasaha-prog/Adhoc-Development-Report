Working of the Script

This script is designed to process XML files for multiple clients and group job execution data by Status and Company ID.

Step-by-Step Working

Status Mapping

Uses a predefined dictionary to convert status codes (like 1, 2, 3) into meaningful labels:

1 → Pending

2 → Running

3 → Completed

4 → Failed
(etc., with descriptions)

Read Clients from CSV

Reads ScheduleRun.csv which contains a column named client_name.

Example CSV:

client_name
ClientA
ClientB

Check Folder Structure

For each client in the CSV, it expects a folder:

<BasePath>\<ClientName>\working\

Inside each working folder, there should be .xml files.

Parse XML Files

For each XML file, extracts:

<Name> → Job Name

<Status> → Job Status

<company_id> → Company Identifier

Group Data

Groups jobs by Status → Company ID → Job Names.

Appends results to an output text file.

Output File

The result file looks like this:

Grouped Job Names by Status and Company ID

Status: 2 (Running) - The job is currently being executed.
  Company ID: C001 (Folder: D:\Base\ClientA\working)
    Name: SalesReport
    Name: InventoryReport

Status: 3 (Completed) - The job has finished execution successfully.
  Company ID: C002 (Folder: D:\Base\ClientB\working)
    Name: PurchaseReport


Warnings

If a client folder doesn’t have working, it prints a warning:

Warning: 'working' folder not found for client: ClientC

▶️ How to Run the Script

1. Prepare Files & Folders

Example folder structure:

D:\Base\
  ClientA\
    working\
      job1.xml
      job2.xml
  ClientB\
    working\
      job3.xml


Example CSV (ScheduleRun.csv):

client_name
ClientA
ClientB

2. Run the Script

Open Command Prompt / Terminal → Navigate to script folder → Run:

3. Enter Required Inputs

When prompted, provide:

Enter the base path for the client folders: D:\Base
Enter the path to the ScheduleRun.csv file: D:\Base\ScheduleRun.csv
Enter the output file path (e.g., outputfile.txt): D:\Base\output_jobs.txt

4. Check Output

After execution, open D:\Base\output_jobs.txt to view grouped results.