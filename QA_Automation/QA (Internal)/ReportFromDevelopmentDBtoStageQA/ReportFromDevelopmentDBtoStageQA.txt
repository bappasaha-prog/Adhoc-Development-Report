README – 

This script works like a migration utility tool.
It copies specific data from development tables to release tables across two PostgreSQL databases.

Think of it as an .exe that:

Reads data from the source DB (ex_content_dev & ex_content_access_dev)

Cleans up matching old data in the target DB (ex_content_release & ex_content_access_release)

Inserts the fresh data into target tables

Logs all actions and errors to a file for tracking

What the script does (step by step)

Connects to Source DB

Database: release_report


Connects to Target DB

Database: report_repository

Host: 172.22.8.9

Fetches rows from Source

From ginview.ex_content_dev where release_version = '202500X'

From ginview.ex_content_access_dev where release_version = '202500X' and a specific party_id

Deletes old rows in Target

Removes rows for release_version = '2025003' from ginview.ex_content_release and ginview.ex_content_access_release

Inserts new rows into Target

Adds the freshly fetched rows into target release tables

Logs everything

Writes process info & errors to: D://updaterepository.txt

Commits or Rollbacks

If success → saves changes

If error → cancels changes (rollback)

How to Run

Only handles release_version = 202500X 

Overwrites old data for that version in the target DB.

Needs valid network connectivity to both databases.

Credentials and host IPs are hard-coded in the script.