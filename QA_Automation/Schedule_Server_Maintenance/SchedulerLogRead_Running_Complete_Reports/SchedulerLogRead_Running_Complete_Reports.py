import os
import re

# Prompt user for base paths
log_dir = input("Enter the base path of the log files (e.g., C:/logs): ").strip()
output_path = input("Enter the full path to save result.txt (e.g., C:/output/result.txt): ").strip()

# List of log files
log_files = [f"eWebReportsScheduler.log"] + [f"eWebReportsScheduler.log.{i}" for i in range(1, 11)]

# Regex patterns
start_pattern = re.compile(r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*Update report in queue: (.+?) \(Job')
end_pattern_1 = re.compile(r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*ReportExecuteEnd.*Report name Path ?: (.+)$')
end_pattern_2 = re.compile(r'(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*Report \'(.+?)\' completed with result: Success')

# Dictionary to hold report execution data
report_info = {}

# Parse each log file
for file_name in log_files:
    file_path = os.path.join(log_dir, file_name)
    if not os.path.exists(file_path):
        continue

    with open(file_path, "r", encoding="utf-8", errors="ignore") as f:
        for line in f:
            # Match report start
            start_match = start_pattern.search(line)
            if start_match:
                timestamp, report_name = start_match.groups()
                report_name = report_name.strip()
                report_info.setdefault(report_name, {})["start"] = timestamp
                continue

            # Match end format 1
            end_match1 = end_pattern_1.search(line)
            if end_match1:
                timestamp, report_name = end_match1.groups()
                report_name = report_name.strip()
                report_info.setdefault(report_name, {})["end"] = timestamp
                continue

            # Match end format 2
            end_match2 = end_pattern_2.search(line)
            if end_match2:
                timestamp, report_name = end_match2.groups()
                report_name = report_name.strip()
                report_info.setdefault(report_name, {})["end"] = timestamp
                continue

# Write results to output file
with open(output_path, "w", encoding="utf-8") as out_file:
    for report, times in sorted(report_info.items()):
        start = times.get("start", "N/A")
        end = times.get("end", "N/A")
        status = "Running" if end == "N/A" else "Executed"
        out_file.write(f"Report: {report}\n  Start: {start}\n  End: {end}\n  Status: {status}\n\n")

print(f"✅ Report execution summary saved to: {output_path}")
