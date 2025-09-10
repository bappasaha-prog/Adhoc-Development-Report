# README – PostgreSQL Report Execution Script

## Purpose
This script automates the following tasks:
1. Extract report names from JSON files inside a directory (`pg_scheduler_jsons`).
2. Save unique report names into a text file (`reportname1.txt`).
3. Run SQL queries for each extracted report name against a PostgreSQL database.  
   - The placeholder `@@` in the SQL file will be replaced by each report name.
4. Save results and logs into different files for traceability.

It helps in batch-processing multiple reports and collecting their SQL execution results automatically.

---

## What You Need Before Running

1. **Database Details**  
   You should know your PostgreSQL:
   - Host
   - Database name
   - Username
   - Password
   - Port

2. **Directory Setup**  
   Inside your chosen base directory, you should have:
   - A folder named **`pg_scheduler_jsons`** containing JSON files with report definitions.
   - A SQL file (e.g., `sql_report.sql`) containing the query with `@@` placeholder.

   Example structure:
   ```
   C:\Project\
       sql_report.sql
       pg_scheduler_jsons\
           scheduler1.json
           scheduler2.json
   ```

3. **SQL File**  
   Your SQL file (e.g., `sql_report.sql`) must contain a query with `@@` placeholder.  
   Example:
   ```sql
   SELECT * FROM reports WHERE report_name = '@@';
   ```

---

## How to Run

1. Open a terminal/command prompt.  
2. Run the script:
   ```bash
   python report_executor.py
   ```
3. Enter required details when prompted:
   ```
   Enter PostgreSQL host: localhost
   Enter database name: mydb
   Enter database user: myuser
   Enter database password: mypass
   Enter database port: 5432
   Enter the directory name to process: C:\Project
   Enter the SQL file name (e.g., sql_report.sql): C:\Project\sql_report.sql
   Enter the path for reportname1.txt: C:\Project\reportname1.txt
   ```

---

## What the Script Does (Step by Step)

### 1. Extract Report Names from JSON
- Looks inside the `pg_scheduler_jsons` folder.  
- For each `.json` file:
  - Reads it.
  - If it contains `"Payload" → "ReportName"`, extracts the report name.  
  - Cleans the report name (removes any `\` path).
- Saves **unique report names** into `reportname1.txt`.

### 2. Create Log Files
- `log.txt`: Notes which report names were found and any errors in JSON parsing.  
- `reportresult.log`: Records SQL execution status, queries, and database connection info.

### 3. Load SQL Query
- Reads the query from `sql_report.sql`.  
- Each occurrence of `@@` is replaced by the actual report name.

### 4. Execute Queries in PostgreSQL
- Connects to the PostgreSQL database using provided credentials.  
- Runs the query for each report name.  
- Writes:
  - **Results** into `sqlresult.txt`.  
  - **Execution logs** into `reportresult.log`.

### 5. Save Results
- `reportname1.txt`: List of unique report names.  
- `sqlresult.txt`: SQL query results (per report).  
- `log.txt`: JSON extraction log.  
- `reportresult.log`: Execution logs and errors.  

---

## Example Workflow

### Example JSON (`pg_scheduler_jsons/scheduler1.json`)
```json
[
  {
    "Payload": {
      "ReportName": "SalesReport"
    }
  }
]
```

### Example SQL (`sql_report.sql`)
```sql
SELECT COUNT(*) FROM sales WHERE report_name = '@@';
```

### Output Files
- **reportname1.txt**
  ```
  SalesReport
  ```
- **sqlresult.txt**
  ```
  Report: SalesReport
  Result: [(42,)]
  ==================================================
  ```
- **log.txt**
  ```
  Found ReportName: SalesReport in scheduler1.json
  ```
- **reportresult.log**
  ```
  Executing query for: SalesReport
  Query: SELECT COUNT(*) FROM sales WHERE report_name = 'SalesReport';
  Success: [(42,)]
  ```

---

## Summary
- Script extracts report names from JSON → saves them.  
- Runs SQL queries for each report → saves results.  
- Maintains separate log files for traceability.  
