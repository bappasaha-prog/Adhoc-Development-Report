Schedule Configuration

1.Create Schedule folder

Tool Used: 1_Scheduler_Migration.exe(Stored in C:\Program Files\Exago)

A .csv file (e.g., MG3.csv) is required, containing client credentials in the following format:
tenantcode_initial_serial, client1 (blank), port

Step 1: Enter the path to the CSV file (default: D:\Exago\MG3.csv)
Example: C:\Program Files\Exago\MG3.csv

Step 2: Enter the path to the source folder (default: D:\Exago\ExagoScheduler_2024.1.1.5_BASE)
Example: C:\Program Files\Exago\ExagoScheduler_2024.1.1.5_BASE

The base folder location will be stored here.

Step3: Enter path for MG3_Updated.csv
Example: C:\Program Files\Exago\MG3_Updated.csv

2.Create Service

Tool Used: 2_SchedulerServiceCreate_migration.exe

Step 1: This executable will create services based on the schedule.csv file.

CSV Format:

ClientnameERP- Tenantcode_initial_serial

Reportclient- initial_serial-scheduler

Port -(allocated client-wise)

Note:
service will be created after executing the exe

3. Port Creation

Tool Used: 3_PortEnabling.exe (stored in C drive)

This tool uses the port.txt file to create and assign ports for each client.

4. Scheduler Migration from Backup

Tool Used: 4_SchedulerxmlfileMIG.exe

Step 1: Enter the path to the CSV file
Example: C:\Program Files\Exago\schedule.csv

Step 2: Enter the base path to the client folders
Example: S:\_PGMigrationBackup\_Clients

Step 3: Enter the path for process.log
Example: C:\Program Files\Exago\process.log

Note:
This tool migrates all XML schedule files from the Oracle backup into their respective client folders.

5. Port Change in Migrated XML Files

Tool Used: 5_Port_Channel_type_change.exe

Step 1: Enter the base path for client folders
Example: C:\Program Files\Exago

Step 2: Enter the path to the CSV file
Example: C:\Program Files\Exago\schedule.csv

Note:
This will update the port numbers in the XML files client-wise, based on the values provided in the CSV.

Final Step:

After completing all migrations and port assignments, fill in the Remote Migration Main Sheet with the Scheduler URL and Port for each client.






