import os

# Get user input for the base folder path
log_dir = input("Enter the base folder path (e.g., C:\\ProgramData\\ReportLogs): ").strip()

# Get user input for the session ID
session_id = input("Enter the Session ID to filter logs: ").strip()

# Get user input for the output file path
output_dir = input("Enter the folder path to save the output file: ").strip()

log_file_name = "eWebReportsScheduler.log"

# Generate output file name based on the folder name
folder_name = os.path.basename(os.path.normpath(log_dir))
output_file = os.path.join(output_dir, f"{folder_name}_{session_id}_all_logs.txt")

# Function to process a single file
def process_file(file_path, session_id):
    matching_logs = []
    try:
        with open(file_path, "r", encoding="utf-8") as file:
            for line in file:
                # Check if the session ID exists in the line
                if session_id in line:
                    matching_logs.append(line.strip())
    except Exception as e:
        print(f"Error processing file {file_path}: {e}")
    return matching_logs

# Validate the log directory
if not os.path.exists(log_dir):
    print(f"The folder path '{log_dir}' does not exist.")
    exit()

# Validate the output directory
if not os.path.exists(output_dir):
    print(f"The output folder path '{output_dir}' does not exist.")
    exit()

# Walk through the directory and find matching logs
all_matching_logs = []
for root, dirs, files in os.walk(log_dir):
    for file in files:
        if file == log_file_name:
            file_path = os.path.join(root, file)
            print(f"Processing file: {file_path}")
            all_matching_logs.extend(process_file(file_path, session_id))

# Check if we found matching logs and save the output
if all_matching_logs:
    try:
        with open(output_file, "w", encoding="utf-8") as output:
            output.write("\n".join(all_matching_logs))
        print(f"\nAll logs related to the session ID saved to: {os.path.abspath(output_file)}")
    except Exception as e:
        print(f"Error saving the log file: {e}")
else:
    print(f"No logs found for the session ID: {session_id}.")

