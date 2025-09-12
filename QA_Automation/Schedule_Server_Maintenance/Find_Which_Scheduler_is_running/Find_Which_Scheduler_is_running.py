import os
import re
from collections import defaultdict

def parse_logs(base_folder):
    log_files = [f"eWebReportsScheduler.log{'' if i == 0 else f'.{i}'}" for i in range(0, 11)]

    # Patterns to match specific tags
    loadxml_pattern = re.compile(r'\[Api\.Scheduler\.SchedulerJob\.LoadXml\]')
    execute_pattern = re.compile(r'\[Api\.Scheduler\.SchedulerJob\.Execute\]')
    report_execute_pattern = re.compile(r'\[Api\.Execute\.ExecuteReport\.Process\] ReportExecuteStart:')

    grouped_data = defaultdict(list)
    current_loadxml = None

    for log_file in log_files:
        filepath = os.path.join(base_folder, log_file)
        if not os.path.isfile(filepath):
            continue

        with open(filepath, 'r', encoding='utf-8', errors='ignore') as file:
            for line in file:
                # Extract the date-time part
                datetime_match = re.match(r'^(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d+)', line)
                log_datetime = datetime_match.group(1) if datetime_match else 'NO_DATETIME'

                if loadxml_pattern.search(line):
                    value = line.split('[Api.Scheduler.SchedulerJob.LoadXml]')[-1].strip()
                    current_loadxml = value
                    grouped_data[current_loadxml].append(f"[LoadXml] {log_datetime} - {value}")
                    continue

                if current_loadxml:
                    if execute_pattern.search(line):
                        value = line.split('[Api.Scheduler.SchedulerJob.Execute]')[-1].strip()
                        grouped_data[current_loadxml].append(f"[Execute] {log_datetime} - {value}")
                    elif report_execute_pattern.search(line):
                        value = line.split('ReportExecuteStart:')[-1].strip()
                        grouped_data[current_loadxml].append(f"[ReportExecuteStart] {log_datetime} - {value}")

    # Save result.txt in the same folder
    result_file = os.path.join(base_folder, 'result.txt')
    with open(result_file, 'w', encoding='utf-8') as output:
        for load_value, items in grouped_data.items():
            output.write(f"### Group: {load_value} ###\n")
            for entry in items:
                output.write(entry + '\n')
            output.write('\n')

    print(f"Parsing complete. Results saved in {result_file}")

if __name__ == "__main__":
    base_path = input("Enter the base folder path: ").strip()
    if os.path.isdir(base_path):
        parse_logs(base_path)
    else:
        print("Invalid folder path.")
