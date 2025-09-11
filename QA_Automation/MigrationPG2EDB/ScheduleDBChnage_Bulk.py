import os
import csv
import xml.etree.ElementTree as ET

def update_xml(file_path, dataconnstr_value, conn_value):
    try:
        tree = ET.parse(file_path)
        root = tree.getroot()

        tag_found = False
        conn_found = False

        # Update <dataconnstr> tag value
        for elem in root.iter("dataconnstr"):
            elem.text = dataconnstr_value
            tag_found = True

        # Also update <option name="ConnectionString" />
        for option in root.iter("option"):
            if option.get("name") == "ConnectionString":
                option.set("value", conn_value)
                conn_found = True

        if tag_found or conn_found:
            tree.write(file_path, encoding="utf-8", xml_declaration=True)
            print(f"  ✅ Updated: {os.path.basename(file_path)}")
        else:
            print(f"  ⚠️ No <dataconnstr> or ConnectionString found in: {os.path.basename(file_path)}")

    except Exception as e:
        print(f"  ❌ Error processing {file_path}: {e}")

# Ask for base folder path
base_folder_path = input("Enter the base folder path: ").strip()

csv_path = os.path.join(base_folder_path, "client.csv")
if not os.path.isdir(base_folder_path) or not os.path.isfile(csv_path):
    print("Invalid base folder path or missing client.csv.")
    exit()

# Read client data
clients = []
with open(csv_path, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    required_cols = {'name', 'dataconnstr', 'ConnectionString'}
    if not required_cols.issubset(reader.fieldnames):
        print("CSV must contain columns: name, dataconnstr, ConnectionString")
        exit()

    for row in reader:
        name = row['name'].strip()
        dataconnstr = row['dataconnstr'].strip()
        conn = row['ConnectionString'].strip()
        if name and dataconnstr and conn:
            clients.append({'name': name, 'dataconnstr': dataconnstr, 'ConnectionString': conn})

if not clients:
    print("No valid client data found.")
    exit()

# Process each client
for client in clients:
    name = client['name']
    dataconnstr_value = client['dataconnstr']
    conn_str = client['ConnectionString']
    working_folder = os.path.join(base_folder_path, name, "working")

    print(f"\n🔧 Processing client: {name}")
    if not os.path.isdir(working_folder):
        print(f"  ❌ Working folder not found: {working_folder}")
        continue

    xml_files = [f for f in os.listdir(working_folder) if f.endswith(".xml")]
    if not xml_files:
        print("  ⚠️ No XML files found.")
        continue

    for xml_file in xml_files:
        xml_path = os.path.join(working_folder, xml_file)
        update_xml(xml_path, dataconnstr_value, conn_str)

print("\n✅ All updates complete.")
