How It Works--?

User Inputs

Source folder path → location of raw XML files.

Destination base folder path → where the organized folder tree will be created.

File Scanning

Loops through all .xml files in the source folder.
Ignores non-XML files.
XML Parsing
Reads each XML file.

Looks for:

<general>
    <temppath>SomePath\SubPath</temppath>
</general>

Folder Creation & Copying

If <temppath> is found:

Builds the folder path: with temp path name

destination_base\SomePath\SubPath

Creates the folder if it doesn’t exist.

Copies the XML file into that folder.

Error Handling

If <temppath> is missing or empty → logs a warning.

If the XML is invalid → logs a parse error.

Any other issues → logs a generic error.

📁 Example
Input

Source Folder:

D:\XML_Files


Destination Base:

D:\Organized

XML File (report1.xml):

<general>
    <temppath>ClientA\Reports</temppath>
</general>

Output

Created folder structure:

D:\Organized\ClientA\Reports\

Copied file:

report1.xml

▶️ How to Run

Run the exe-

When prompted:

Enter the source folder path.-Enter the path to the folder containing XML files:

Enter the destination base path.-Enter the destination base path where folder will be created: