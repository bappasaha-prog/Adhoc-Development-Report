import os
import shutil
import xml.etree.ElementTree as ET

# Ask user for the base folder path
base_folder = input("Enter the base folder path: ")

# Check if the base folder exists
if not os.path.exists(base_folder):
    print(f"Error: The folder '{base_folder}' does not exist!")
    exit()

# Loop through all subdirectories inside the base folder
for sub_folder in os.listdir(base_folder):
    sub_folder_path = os.path.join(base_folder, sub_folder)

    # Ensure it is a directory
    if os.path.isdir(sub_folder_path):
        # Define the expected working folder path
        working_folder = os.path.join(sub_folder_path, "GinesysReport", "ReportScheduler", "working")

        # Check if the working folder exists
        if os.path.exists(working_folder):
            # Define the destination folder inside the working folder
            ready_folder = os.path.join(working_folder, "ReadySche")
            os.makedirs(ready_folder, exist_ok=True)

            # Iterate over XML files in the working folder
            for filename in os.listdir(working_folder):
                if filename.endswith(".xml"):  # Process only XML files
                    file_path = os.path.join(working_folder, filename)

                    try:
                        # Parse XML file
                        tree = ET.parse(file_path)
                        root = tree.getroot()

                        # Search for <Status>2</Status>
                        for status in root.findall(".//Status"):
                            if status.text.strip() == "2":
                                # Move the file to the "ReadySche" folder
                                shutil.move(file_path, os.path.join(ready_folder, filename))
                                print(f"Moved: {filename} -> {ready_folder}")
                                break  # Move to the next file after finding Status 2
                    except ET.ParseError:
                        print(f"Error parsing {filename}, skipping...")

print("\nProcessing completed! Files with <Status>2</Status> are moved to respective 'ReadySche' folders.")
