import os

# Get the folder path from the user
folder_path = input("Enter the folder path: ")

# Validate the folder path
if not os.path.exists(folder_path):
    print("The given path does not exist. Please check and try again.")
else:
    # Get all folder names in the directory
    folder_names = [f.name for f in os.scandir(folder_path) if f.is_dir()]
    
    # Define the output file name and path
    output_file = os.path.join(folder_path, "foldername.txt")
    
    # Write the folder names to the file
    try:
        with open(output_file, 'w') as file:
            file.write("\n".join(folder_names))
        print(f"Folder names have been successfully written to {output_file}")
    except Exception as e:
        print(f"An error occurred: {e}")
