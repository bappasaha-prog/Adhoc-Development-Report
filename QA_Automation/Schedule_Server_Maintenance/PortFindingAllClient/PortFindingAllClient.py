import os
import csv
import xml.etree.ElementTree as ET

# Ask user for input path
base_path = input("Enter the base directory path: ").strip()

# File paths
client_file = os.path.join(base_path, "clientname.txt")
output_csv = os.path.join(base_path, "shudderdetails.csv")

# Tags to extract
tags = [
    "smtp_server", "smtp_enable_ssl", "smtp_user_id", "smtp_password", 
    "smtp_from", "smtp_from_name", "error_report_to", "channel_type", 
    "port", "working_directory", "default_job_timeout", "sleep_time", 
    "simultaneous_job_max", "logging", "flush_time", "sync_flush_time", 
    "email_addendum", "external_interface", "report_path", 
    "abend_upon_report_error", "ip_address", "security_protocol", 
    "encrypt_schedule_files", "max_temp_file_age", "email_retry_time", 
    "queue_service"
]

# Check if clientname.txt exists
if not os.path.exists(client_file):
    print(f"Error: {client_file} not found.")
    exit(1)

# Read folder names from clientname.txt
with open(client_file, "r") as f:
    folders = [line.strip() for line in f if line.strip()]

# Prepare CSV file
with open(output_csv, "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["Folder"] + tags)  # Header row

    for folder in folders:
        xml_path = os.path.join(base_path, folder, "eWebReportsScheduler.xml")

        if os.path.exists(xml_path):
            tree = ET.parse(xml_path)
            root = tree.getroot()

            # Extract tag values
            values = [folder]  # Start with folder name
            for tag in tags:
                element = root.find(tag)
                values.append(element.text if element is not None else "N/A")

            writer.writerow(values)

print(f"Data extraction complete. Check '{output_csv}'.")
