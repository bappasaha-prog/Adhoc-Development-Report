Folder Name Extractor

This Python script allows you to list all the folder names inside a given directory and saves them into a text file (foldername.txt) in the same directory.

It is useful if you want a quick way to export all subfolder names for documentation, backup, or analysis purposes.

How It Works---

The script asks the user to enter a folder path.

It checks whether the given path exists.

If not, it shows an error message.

If the path exists:

It scans the directory for all subfolders.

Collects their names.

Saves them into a file called foldername.txt inside the same directory.

Displays a success message with the location of the generated file.

Input:
Enter the folder path: C:\Users\John\Documents
Output File (C:\Users\John\Documents\foldername.txt):

Projects
Reports
Invoices
Personal

▶️ How to Run

Enter the full path of the folder when prompted.

Works on Windows, macOS, and Linux.

Automatically saves results in the selected directory.

Simple and lightweight (uses only Python’s built-in os module).