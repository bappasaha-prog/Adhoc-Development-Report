import os
import csv

def get_folder_size(folder):
    """Returns the size of a folder in bytes."""
    total_size = 0
    for dirpath, _, filenames in os.walk(folder):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.exists(fp):  # Ensure file exists before getting size
                total_size += os.path.getsize(fp)
    return total_size

def save_folder_sizes_to_csv(base_path, output_file="c:\\FolderSizeReport.csv"):
    """Saves the size of each subfolder inside base_path to a CSV file."""
    with open(output_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(["Folder Name", "Size (GB)"])
        
        for folder in os.listdir(base_path):
            folder_path = os.path.join(base_path, folder)
            if os.path.isdir(folder_path):
                size_gb = get_folder_size(folder_path) / (1024 ** 3)
                writer.writerow([folder, f"{size_gb:.2f}"])
                print(f"Processed: {folder} -> {size_gb:.2f} GB")
    print(f"Folder size details saved to {output_file}")

if __name__ == "__main__":
    user_folder = input("Enter the folder path to check space usage: ")
    if os.path.exists(user_folder) and os.path.isdir(user_folder):
        save_folder_sizes_to_csv(user_folder)
    else:
        print("Invalid folder path. Please provide a valid directory.")
