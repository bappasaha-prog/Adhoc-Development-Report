Location:Z:\_PGMigrationBackup\_GinesysReportMigration\Application

Step1:Validate files:
1.Location:  Z:\_PGMigrationBackup\_GinesysReportMigration\Application\sql_scripts\PG_Report_Migration_Script1.SQL
==> Look for stage state server ip : 172.28.8.9
==> Line Looks like "OPTIONS (host '172.28.8.9', dbname 'report_repository', port '5432');"

2.Location Z:\_PGMigrationBackup\_GinesysReportMigration\Application\azure_container_connection_details.ini
==> Look for stage azure storage container
==> Looks like : 
"DefaultEndpointsProtocol=https;AccountName=storageerpreportstage;AccountKey=R/lu2xhjpQrygObH2wsctRjLgQ/25Q+M61Frk+9cgKdDPCtW4KoKEHNvtwBXI2z0y5eGzIj0Krix+ASt5V1vlw==;EndpointSuffix=core.windows.net;"

Step2:Google Sheet : ginesys-remote-migration-sheet and sheet name is : Main

Step3:Migration Actions : 
1. Schedule BackUP : 
a. Get client initial_serials from google sheet 'ginesys-remote-migration-sheet' ams Sheet is : "Main"
b. Modify .bat file located at 'C:\Users\ReportAdministrator\Desktop\Backup_scheduler.bat'
If there are 5 client then bat file will contain 5 lines looks like
start cmd /k "O:\_PGMigrationBackup\_GinesysReportMigration\Application\reportmigration.exe O:\_PGMigrationBackup <<initial_serial>> 7"

Note:we have replace <<initail_serial>> with client actual initial_serial collected from google sheet.

Step4:Save:
Save bat file.

C. Check the Scheduler Folder located in :- Z:/_PGmigrationBackup/_Clients

Step 5: Run Bat file:
Run the .bat file located at 'C:\Users\ReportAdministrator\Desktop\Backup_scheduler.bat'


Step6: Log Check
Locatio: Z:\_PGMigrationBackup\_GinesysReportMigration\ExecutionLogs\<<initial_serial>>_schedule.log
         For execution Log Check :- Z:\_PGMigrationBackup\_GinesysReportMigration\ExecutionLogs\<<initial_serial>>_schedule.log

Step7:Schedule Backup Validation:
Check client wise folders :
Location:
Z:\_PGMigrationBackup\_GinesysReportMigration\ClientReportObjects\<<Tenant_initial_serial>>\pg_scheduler_jsons

Also a backup csv file for full details:
Z:\_PGMigrationBackup\_GinesysReportMigration\ClientReportObjects\<<Tenant_initial_serial>>\status_scheduler_backup.csv










