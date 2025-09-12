import os

# Path to the text file containing folder names
file_path = r"c:\Foldername.txt"

# Read folder names from the file
try:
    with open(file_path, 'r') as file:
        folder_names = file.readlines()
    
    # Create each folder
    for folder_name in folder_names:
        folder_name = folder_name.strip()  # Remove any leading/trailing whitespace
        if folder_name:  # Ensure it's not an empty line
            folder_path = os.path.join(r"C:\ProgramData\ReportLogs", folder_name)  # Specify the base directory (C:\ here)
            try:
                os.makedirs(folder_path, exist_ok=True)
                print(f"Folder created: {folder_path}")
            except Exception as e:
                print(f"Error creating folder {folder_path}: {e}")
except FileNotFoundError:
    print(f"The file {file_path} does not exist.")
except Exception as e:
    print(f"An error occurred: {e}")
