@echo off
start cmd /k "S:\_PGMigrationBackup\_GinesysReportMigration\Application\reportmigration.exe S:\_PGMigrationBackup RFOR_RND 7"
start cmd /k "S:\_PGMigrationBackup\_GinesysReportMigration\Application\reportmigration.exe S:\_PGMigrationBackup SGHO_RND 7"
pause
