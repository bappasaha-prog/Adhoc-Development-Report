Working of the Script

This script checks for report scheduler XML files for multiple clients and logs whether their schedules exist and how many are in a “Ready” state (<Status>2</Status>).

Here’s what it does step by step:

Takes Inputs

base_path → The root folder where client directories are stored.

csv_file → Path to a CSV file containing client details. The CSV must have a column named clientname.

Creates/Initializes a Log File

Creates scheduleExist.txt inside the base_path.

Writes headers:

Client   Total XML Files   Ready Files (<Status>2</Status>)

Reads Client List from CSV

Opens the CSV file.

For each row, reads the clientname value.

Skips the row if clientname is missing.

Checks Each Client’s Scheduler Folder

Builds path:

<base_path>\<clientname>\GinesysReport\ReportScheduler\working

If folder exists:

Counts all .xml files inside.

Opens each .xml file and checks if it contains <Status>2</Status>.

Counts how many files are in “Ready” state.

Logs the result as:

clientname    total_xml_files    ready_files

If folder doesn’t exist:

Logs as:

clientname    Folder Not Found   -

Error Handling

If the CSV file is missing, logs the error.

If an XML file can’t be read, logs the error with the filename.

If any other exception occurs, it is logged.

Completion

Prints the path to the log file so the user knows where to check the results.


How to Run

Run it in a terminal/command prompt/exe:


Enter the required inputs when prompted:

Enter the base path (e.g., D:\SchTest): D:\SchTest
Enter the path to the client CSV file (e.g., client.csv): client.csv

What It Does

Creates scheduleExist.txt in the base path

For each client:

Looks inside GinesysReport\ReportScheduler\working

Counts total XML files

Counts XML files with <Status>2</Status>

Logs the result in the format:

Client      Total XML Files    Ready Files (<Status>2</Status>)
---------------------------------------------------------------
ClientA     5                  3
ClientB     Folder Not Found   -
ClientC     0                  0

Output

Check the file:

<base_path>\scheduleExist.txt