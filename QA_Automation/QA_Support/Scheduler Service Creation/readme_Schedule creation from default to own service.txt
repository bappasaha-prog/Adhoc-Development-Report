
Schedule Segregation from Default to Own Service

1. Segregate from Default Working Folder

Tool Used: ScheduleDistribute2AnotherSystem.exe

Step 1: Enter the path to the folder containing XML files:
C:\Program Files\Exago\ExagoScheduler\working

Step 2: Enter the destination path where the folders will be created:
C:\ProgramData\ReportLogs

Note:
Use this executable to segregate each client's schedules from the default working folder. 
It will create a folder for each client using the initial serial name, and a copy of the XML files will be saved client-wise.

2. Create Schedule, Service, and Port Client-Wise

Tool Used: 1_Scheduler_Migration.exe

A .csv file (e.g., MG3.csv) is required, containing client credentials in the following format:
tenantcode_initial_serial, client1 (blank), port

Step 1: Enter the path to the CSV file (default: D:\Exago\MG3.csv)
Example: C:\Program Files\Exago\MG3.csv

Step 2: Enter the path to the source folder (default: D:\Exago\ExagoScheduler_2024.1.1.5_BASE)
Example: C:\Program Files\Exago\ExagoScheduler_2024.1.1.5_BASE

The base folder location will be stored here.

Step3: Enter path for MG3_Updated.csv
Example: C:\Program Files\Exago\MG3_Updated.csv

Tool Used: 2_SchedulerServiceCreate_migration.exe

Step 1: This executable will create services based on the schedule.csv file.

CSV Format:

ClientnameERP- tenantcode_initial_serial

Reportclient- initial_serial-scheduler

Port -(allocated client-wise)

Note:
service will be created afyer executing the exe

Tool Used: 3_PortEnabling.exe

This uses port.txt to create and assign ports.

3. Delete XML Files from Default Working Folder (Already Segregated)

Save this 'SchedulerFileDeleteFromDefaultSchduleFolder' inside the working folder of the default scheduler.

Tool Used: SchedulerFileDeleteFromDefaultSchduleFolder.exe

Step 1: Enter the base folder where the client-wise XML files are stored:
Example: C:\ProgramData\ReportLogs\AHHO_21300

Step 2: Enter the "delete from" folder path (default working folder):
Example: C:\Program Files\Exago\ExagoScheduler\working

The executable will delete the XML files from the default folder that have already been segregated.

Final Step:
Store the working folders for each client in the respective created folders. Then, restart both the default and newly created services.


