README – Move XML Files with <Status>2</Status> to Ready Folder

This script scans XML files in a specified folder structure, looks for <Status>2</Status> tags inside the XML content, and moves those files to a ReadySche folder inside the same working directory.

It is typically used for Ginesys report scheduler workflows to separate "ready" XML files from the rest.

How the Script Works
1. User Input

The script prompts for the base folder path where client subfolders are located.

Enter the base folder path: D:\SchTest

2. Folder Structure

The script expects the following structure inside each client folder:

<BaseFolder>\<ClientName>\GinesysReport\ReportScheduler\working\

The XML files to process are located inside the working folder.

3. Processing Each Subfolder

For each subfolder inside the base folder:

Check if GinesysReport\ReportScheduler\working exists.

Create a subfolder ReadySche inside working if it doesn’t exist.

4. Processing XML Files

Iterates over all .xml files inside working.

For each XML file:

Parse the XML file using Python’s xml.etree.ElementTree.

Search for <Status> tags anywhere in the XML tree.

If any <Status> tag contains the value "2":

Move the XML file to the ReadySche folder.

Print a confirmation message.

XML files without <Status>2</Status> are left untouched.

If an XML file cannot be parsed (invalid XML), it is skipped with a warning message.

5. Output

After processing, all XML files with <Status>2</Status> are moved into ReadySche folders inside their respective working directories.

Example output in console:

Moved: Report123.xml -> D:\SchTest\ClientA\GinesysReport\ReportScheduler\working\ReadySche
Moved: Report456.xml -> D:\SchTest\ClientB\GinesysReport\ReportScheduler\working\ReadySche

6. Completion

After all subfolders are processed, the script prints:

Processing completed! Files with <Status>2</Status> are moved to respective 'ReadySche' folders.

Notes

Only files with .xml extension are processed.

The script does not modify files that do not have <Status>2</Status>.

Handles XML parse errors gracefully and skips invalid files.

Creates the ReadySche folder automatically if it doesn’t exist.

How to run-

Save the Script

Save your script in a .py file, for example:

move_ready_xml.py

3. Prepare the Folder Structure

Ensure your base folder contains subfolders for each client.

Each client folder should have the path:

<BaseFolder>\<ClientName>\GinesysReport\ReportScheduler\working\

XML files to be processed should be inside the working folder.

4. Run the Script

Open Command Prompt (Windows) or Terminal (Mac/Linux).

Navigate to the folder where the script is saved.

Run the exe

5. Enter the Base Folder Path

When prompted, input the path to your base folder:

Enter the base folder path: D:\SchTest

6. Script Execution

The script will:

Scan all client subfolders inside the base folder.

Check each XML file in the working folder.

Move files with <Status>2</Status> to ReadySche folder.

You will see console messages like:

Moved: Report123.xml -> D:\SchTest\ClientA\GinesysReport\ReportScheduler\working\ReadySche

7. Completion

After all folders are processed, the script prints:

Processing completed! Files with <Status>2</Status> are moved to respective 'ReadySche' folders.

You can now check the ReadySche folders in each client’s working directory for the processed XML files.