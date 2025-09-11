import os
import csv
import xml.etree.ElementTree as ET
from collections import defaultdict

# Status code and description mapping
status_description = {
    "1": ("Pending", "The job is queued and waiting to be executed."),
    "2": ("Running", "The job is currently being executed."),
    "3": ("Completed", "The job has finished execution successfully."),
    "4": ("Failed", "The job has failed during execution."),
    "5": ("Success", "The job completed successfully without errors."),
    "6": ("Canceled", "The job was canceled before completion."),
    "7": ("Paused", "The job is paused and not running.")
}

# Function to remove namespaces from XML tags
def remove_namespace(tag):
    if '}' in tag:
        return tag.split('}', 1)[1]  # Remove the namespace
    return tag

# Function to parse XML and group by Status and company_id
def parse_and_group_by_status(input_file, folder_path, output_file):
    # Parse the XML file
    tree = ET.parse(input_file)
    root = tree.getroot()

    # Dictionary to store the names grouped by status and company_id
    grouped_data = defaultdict(lambda: defaultdict(list))

    # Iterate through the XML tree and extract <Name>, <Status>, and <company_id>
    for jobinfo in root.findall('.//jobinfo'):
        name = jobinfo.find('Name')
        status = jobinfo.find('Status')
        company_id_element = jobinfo.find('company_id')

        # Extract text from Name, Status, and company_id
        if name is not None:
            name = name.text.strip()
        if status is not None:
            status = status.text.strip()
        if company_id_element is not None:
            company_id = company_id_element.text.strip()  # Ensure no leading/trailing spaces
        else:
            company_id = "Unknown"

        # Add the folder path to company_id
        company_id_with_path = f"{company_id} (Folder: {folder_path})"

        # Group by Status and then company_id
        grouped_data[status][company_id_with_path].append(name)

    # Write the grouped data to the output file
    with open(output_file, 'a') as f:  # Open in append mode
        # Iterate over the grouped data
        for status, companies in grouped_data.items():
            # Get the status code and description
            status_code, status_desc = status_description.get(status, ("Unknown", "No description available"))
            f.write(f"Status: {status} ({status_code}) - {status_desc}\n")
            
            # Sort company IDs and jobs within each status
            for company_id, names in sorted(companies.items()):
                f.write(f"  Company ID: {company_id}\n")
                for name in names:
                    f.write(f"    Name: {name}\n")
            f.write("\n")

# Function to process the client folders from ScheduleRun.csv
def process_client_folders(csv_file, base_path, output_file):
    # Read the ScheduleRun.csv file to get client folder names
    with open(csv_file, newline='', encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        
        # Iterate through each row in the CSV
        for row in reader:
            client_name = row['client_name']  # Assuming column is named 'client_name'
            client_folder = os.path.join(base_path, client_name, 'working')
            
            # Ensure the 'working' folder exists
            if os.path.exists(client_folder):
                # Process all XML files in the 'working' folder
                for filename in os.listdir(client_folder):
                    if filename.endswith(".xml"):
                        file_path = os.path.join(client_folder, filename)
                        print(f"Processing file: {file_path}")  # Print the full path of the XML file
                        parse_and_group_by_status(file_path, client_folder, output_file)
            else:
                print(f"Warning: 'working' folder not found for client: {client_name}")

# Main function to execute the process
def main():
    # Take input for base path, CSV file, and output file
    base_path = input("Enter the base path for the client folders: ").strip()
    csv_file = input("Enter the path to the ScheduleRun.csv file: ").strip()
    output_file = input("Enter the output file path (e.g., outputfile.txt): ").strip()
    
    # Check if the CSV file exists
    if not os.path.exists(csv_file):
        print(f"Error: The CSV file '{csv_file}' does not exist.")
        return
    
    # Check if the base path exists
    if not os.path.exists(base_path):
        print(f"Error: The base path '{base_path}' does not exist.")
        return
    
    # Clear the output file before writing new data
    with open(output_file, 'w') as f:
        f.write("Grouped Job Names by Status and Company ID\n")
    
    # Process the client folders
    process_client_folders(csv_file, base_path, output_file)

if __name__ == "__main__":
    main()
