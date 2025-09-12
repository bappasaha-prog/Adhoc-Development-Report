import os
import shutil
import xml.etree.ElementTree as ET
from pathlib import Path

def organize_xml_by_temppath():
    # Prompt user for the source folder path
    source_folder = input("Enter the path to the folder containing XML files: ").strip()
    if not os.path.isdir(source_folder):
        print(f"Error: The path '{source_folder}' is not a valid directory.")
        return

    # Prompt user for the destination base folder path
    destination_base = input("Enter the destination base path where folders will be created: ").strip()
    if not os.path.isdir(destination_base):
        print(f"Error: The path '{destination_base}' is not a valid directory.")
        return

    # Iterate over all XML files in the source folder
    for filename in os.listdir(source_folder):
        if filename.lower().endswith('.xml'):
            file_path = os.path.join(source_folder, filename)
            try:
                # Parse the XML file
                tree = ET.parse(file_path)
                root = tree.getroot()

                # Attempt to find the <temppath> element
                temppath_elem = root.find(".//general/temppath")
                if temppath_elem is not None and temppath_elem.text:
                    temppath_value = temppath_elem.text.strip()

                    # Create the destination directory based on <temppath> within the destination base path
                    dest_dir = Path(destination_base) / Path(temppath_value)
                    dest_dir.mkdir(parents=True, exist_ok=True)

                    # Copy the XML file to the destination directory
                    shutil.copy2(file_path, dest_dir / filename)
                    print(f"Copied '{filename}' to '{dest_dir}'")
                else:
                    print(f"[Warning] <temppath> not found or empty in '{filename}'")
            except ET.ParseError as e:
                print(f"[Error] Failed to parse '{filename}': {e}")
            except Exception as e:
                print(f"[Error] An error occurred while processing '{filename}': {e}")

if __name__ == "__main__":
    organize_xml_by_temppath()
