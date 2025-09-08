import os
import xml.etree.ElementTree as ET
import csv

def read_data_from_xml(xml_file_path, key):
    try:
        tree = ET.parse(xml_file_path)
        root = tree.getroot()
        return root.findtext(key, default='')
    except Exception as e:
        print(f"Error reading '{key}' from '{xml_file_path}': {e}")
        return ''

def write_to_csv(row, csv_file_path):
    file_exists = os.path.isfile(csv_file_path)
    try:
        with open(csv_file_path, mode='a', newline='', encoding='utf-8-sig') as file:
            writer = csv.writer(file)
            if not file_exists or os.stat(csv_file_path).st_size == 0:
                writer.writerow([
                    'client_folder', 'job_id', 'job_status', 'client', 'schedule_name',
                    'report_name', 'schedule_type', 'schedule_job_type',
                    'Recurrence', 'Type', 'status', 'details'
                ])
            writer.writerow(row)
    except Exception as e:
        print(f"Error writing to CSV: {e}")

def process_working_folder(client_folder_path, client_folder_name, csv_file_path):
    # Now go only to the working folder directly under client folder
    working_folder = os.path.join(client_folder_path, 'working')

    if not os.path.isdir(working_folder):
        print(f"⚠️  No 'working' folder found in: {client_folder_path}")
        write_to_csv([
            client_folder_name, '', 'N/A', client_folder_name, '', '',
            'N/A', 'N/A', '', 'Report',
            'Exception', f"Missing 'working' folder: {working_folder}"
        ], csv_file_path)
        return

    xml_found = False
    for file_name in os.listdir(working_folder):
        if file_name.lower().endswith('.xml'):
            xml_found = True
            xml_file_path = os.path.join(working_folder, file_name)
            job_id = os.path.splitext(file_name)[0]

            print(f"✅ Processing: {xml_file_path}")

            schedule_type = read_data_from_xml(xml_file_path, 'schedule/report_type')
            schedule_job_type = read_data_from_xml(xml_file_path, 'jobinfo/Type')
            job_status = read_data_from_xml(xml_file_path, 'jobinfo/Status')

            write_to_csv([
                client_folder_name,
                job_id,
                job_status,
                client_folder_name,
                '', '',  # schedule_name, report_name
                schedule_type,
                schedule_job_type,
                '',       # Recurrence
                'Report',
                'Success',
                'Successfully processed'
            ], csv_file_path)

    if not xml_found:
        print(f"ℹ️  No XML files found in: {working_folder}")
        write_to_csv([
            client_folder_name, '', 'N/A', client_folder_name, '', '',
            'N/A', 'N/A', '', 'Report',
            'Skipped', 'No XML files found'
        ], csv_file_path)

def main():
    base_path = input("Enter the base folder path (e.g. D:\\AT\\BT): ").strip()
    output_csv_path = input("Enter full path for 'status_scheduler_backup.csv': ").strip()

    if not os.path.isdir(base_path):
        print(f"❌ Base path not found: {base_path}")
        return

    for client_folder in os.listdir(base_path):
        client_folder_path = os.path.join(base_path, client_folder)
        if os.path.isdir(client_folder_path):
            print(f"\n--- 🔍 Processing client folder: {client_folder} ---")
            process_working_folder(client_folder_path, client_folder, output_csv_path)

    print(f"\n✅ All data written to: {output_csv_path}")

if __name__ == "__main__":
    main()
