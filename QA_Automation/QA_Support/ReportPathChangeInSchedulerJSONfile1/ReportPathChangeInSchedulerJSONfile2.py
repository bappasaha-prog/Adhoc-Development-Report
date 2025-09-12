import os
import json
import psycopg2

# Get database connection details
host = input("Enter PostgreSQL host: ").strip()
dbname = input("Enter database name: ").strip()
user = input("Enter database user: ").strip()
password = input("Enter database password: ").strip()
port = input("Enter database port: ").strip()

directory = input("Enter the directory name to process: ").strip()
sql_file_path = input("Enter the SQL file name (e.g., sql_report.sql): ").strip()
reportname1_output_path = input("Enter the path for reportname1.txt: ").strip()
sql_result_path = os.path.join(directory, "sqlresult.txt")
log_path = os.path.join(directory, "log.txt")
report_result_log = os.path.join(directory, "reportresult.log")
scheduler_json_path = os.path.join(directory, "pg_scheduler_jsons")

# Dictionary to store unique ReportNames
unique_report_names = set()

with open(log_path, "w", encoding="utf-8") as log_file, open(report_result_log, "w", encoding="utf-8") as report_log:
    log_file.write("Log File for Report Name Extraction\n" + "=" * 50 + "\n\n")
    report_log.write("Report Execution Log\n" + "=" * 50 + "\n\n")

    # Step 1: Extract Report Names from JSON
    if os.path.exists(scheduler_json_path):
        log_file.write(f"Processing directory: {scheduler_json_path}\n")
        print(f"Checking directory: {scheduler_json_path}")

        for root, _, files in os.walk(scheduler_json_path):
            for file in files:
                if file.endswith(".json"):
                    json_path = os.path.join(root, file)
                    try:
                        with open(json_path, "r", encoding="utf-8") as json_file:
                            data = json.load(json_file)
                            if isinstance(data, list):
                                for entry in data:
                                    if isinstance(entry, dict) and "Payload" in entry and isinstance(entry["Payload"], dict):
                                        if "ReportName" in entry["Payload"]:
                                            report_name = entry["Payload"]["ReportName"].split("\\")[-1]
                                            unique_report_names.add(report_name)
                                            log_file.write(f"Found ReportName: {report_name} in {json_path}\n")
                                            print(f"Found: {report_name}")
                    except (json.JSONDecodeError, IOError) as e:
                        log_file.write(f"Error reading {json_path}: {e}\n")
                        print(f"Error reading {json_path}: {e}")
    else:
        log_file.write(f"Directory not found: {scheduler_json_path}\n")
        print(f"Directory not found: {scheduler_json_path}")

    # Step 2: Save unique report names
    with open(reportname1_output_path, "w", encoding="utf-8") as f:
        for report in sorted(unique_report_names):
            f.write(f"{report}\n")
            print(report)

    print(f"Unique report names saved to {reportname1_output_path}")
    print(f"Log file saved to {log_path}")

    # Step 3: Read SQL query from file
    if os.path.exists(sql_file_path):
        with open(sql_file_path, "r", encoding="utf-8") as sql_file:
            sql_query = sql_file.read().strip()
            report_log.write(f"SQL Query Loaded: {sql_query}\n\n")
    else:
        report_log.write(f"SQL file {sql_file_path} not found.\n")
        print(f"SQL file {sql_file_path} not found.")
        exit(1)

    # Step 4: Execute SQL Queries
    try:
        conn = psycopg2.connect(host=host, dbname=dbname, user=user, password=password, port=port)
        cur = conn.cursor()
        report_log.write("Database Connection Successful.\n")

        with open(sql_result_path, "w", encoding="utf-8") as result_file:
            for report_name in unique_report_names:
                query = sql_query.replace("@@", report_name)
                report_log.write(f"\nExecuting query for: {report_name}\nQuery: {query}\n")
                print(f"Executing query for: {report_name}")

                try:
                    cur.execute(query)
                    result = cur.fetchall()
                    result_file.write(f"Report: {report_name}\nResult: {result}\n{'='*50}\n")
                    report_log.write(f"Success: {result}\n")
                    print(f"Result for {report_name}: {result}")
                except Exception as e:
                    result_file.write(f"Report: {report_name}\nError: {e}\n{'='*50}\n")
                    report_log.write(f"Error executing query for {report_name}: {e}\n")
                    print(f"Error executing query for {report_name}: {e}")

        cur.close()
        conn.close()
        report_log.write("SQL execution completed successfully.\n")
        print(f"SQL execution results saved to {sql_result_path}")
    
    except Exception as e:
        report_log.write(f"Database connection failed: {e}\n")
        print(f"Database connection failed: {e}")

print(f"Report execution log saved to {report_result_log}")
