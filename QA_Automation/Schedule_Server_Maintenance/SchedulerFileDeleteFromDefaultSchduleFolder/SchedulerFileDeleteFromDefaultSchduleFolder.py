import os

def get_all_filenames(base_path):
    filenames = set()
    has_subfolders = any(os.path.isdir(os.path.join(base_path, item)) for item in os.listdir(base_path))

    if has_subfolders:
        for root, dirs, files in os.walk(base_path):
            for file in files:
                filenames.add(file)
    else:
        filenames = set(os.listdir(base_path))
    
    return filenames

def delete_matching_files(delete_from_path, filenames_to_delete):
    deleted_files = []
    not_found = []

    for file in os.listdir(delete_from_path):
        file_path = os.path.join(delete_from_path, file)
        if file in filenames_to_delete and os.path.isfile(file_path):
            os.remove(file_path)
            deleted_files.append(file)
        elif file in filenames_to_delete:
            not_found.append(file)

    print("\n✅ Deleted files:")
    for file in deleted_files:
        print(f" - {file}")

    if not_found:
        print("\n⚠️ These matched but could not be deleted (maybe permission issue or not a file):")
        for file in not_found:
            print(f" - {file}")

# MAIN
base_folder = input("Enter base folder path: ").strip()
delete_from_folder = input("Enter 'will be delete from' folder path: ").strip()

if not os.path.isdir(base_folder):
    print("❌ Base folder path does not exist.")
elif not os.path.isdir(delete_from_folder):
    print("❌ 'Will be delete from' folder path does not exist.")
else:
    files_to_delete = get_all_filenames(base_folder)
    delete_matching_files(delete_from_folder, files_to_delete)
