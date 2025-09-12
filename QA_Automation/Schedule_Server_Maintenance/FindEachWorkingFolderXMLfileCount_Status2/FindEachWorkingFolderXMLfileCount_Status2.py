import csv
import os

# Get base path and client CSV file path
base_path = input("Enter the base path (e.g., D:\\SchTest): ").strip()
csv_file = input("Enter the path to the client CSV file (e.g., client.csv): ").strip()

# Log file setup
log_file_path = os.path.join(base_path, "scheduleExist.txt")

def log_message(message):
    """Write a message to the log file."""
    with open(log_file_path, "a") as log_file:
        log_file.write(message + "\n")

try:
    # Initialize or clear the log file
    with open(log_file_path, "w") as log_file:
        log_file.write("Schedule Existence Log\n")
        log_file.write("=" * 60 + "\n")
        log_file.write("Client\tTotal XML Files\tReady Files (<Status>2</Status>)\n")
        log_file.write("-" * 60 + "\n")

    # Read the client CSV file
    with open(csv_file, 'r') as csvfile:
        reader = csv.DictReader(csvfile)
        
        if 'clientname' not in reader.fieldnames:
            raise ValueError("'clientname' column not found in the CSV file.")
        
        for row in reader:
            client_name = row.get('clientname')
            
            if not client_name:
                log_message(f"Skipping row with empty 'clientname' value.")
                continue
            
            working_folder_path = os.path.join(base_path, client_name, "GinesysReport", "ReportScheduler", "working")
            print(f"Checking path: {working_folder_path}")
            
            if os.path.exists(working_folder_path) and os.path.isdir(working_folder_path):
                xml_files = [f for f in os.listdir(working_folder_path) if f.endswith('.xml')]
                xml_count = len(xml_files)

                ready_count = 0
                for xml_file in xml_files:
                    file_path = os.path.join(working_folder_path, xml_file)
                    try:
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                            if "<Status>2</Status>" in content:
                                ready_count += 1
                    except Exception as e:
                        log_message(f"Error reading file {file_path}: {e}")
                
                log_message(f"{client_name}\t{xml_count}\t{ready_count}")
            else:
                log_message(f"{client_name}\tFolder Not Found\t-")

except FileNotFoundError:
    log_message(f"Error: The file '{csv_file}' was not found.")
except Exception as e:
    log_message(f"Error processing the client CSV file: {e}")

print(f"Process complete. Check the scheduleExist.txt log file at: {log_file_path}")
