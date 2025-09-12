Folder Size Report Generator

Overview--

This Python script scans a given directory and calculates the size of each subfolder inside it.
It then saves the results into a CSV file (FolderSizeReport.csv) for easy review.

This is useful for checking disk usage and identifying which folders consume the most space.

How It Works

The script prompts the user for a folder path.

It checks if the given path exists and is a valid directory.

For each subfolder inside the given directory:

Calculates the total size (by summing up all files inside the subfolder, including nested files).

Converts the size into gigabytes (GB).

Records the result in a CSV file.

The CSV file is saved at:

C:\FolderSizeReport.csv


While processing, the script also prints progress in the console.

📝 Example

Input when running script:

Enter the folder path to check space usage: D:\Projects


Console Output:

Processed: App1 -> 1.24 GB
Processed: App2 -> 3.78 GB
Processed: Logs -> 0.56 GB
Folder size details saved to c:\FolderSizeReport.csv


Generated CSV file (C:\FolderSizeReport.csv):

Folder Name,Size (GB)
App1,1.24
App2,3.78
Logs,0.56

▶️ How to Run

Run the script in terminal/command prompt/exe:

Enter the folder path when prompted.

Check the generated CSV at C:\FolderSizeReport.csv.

Features

Scans all subfolders inside a directory.

Calculates size accurately (includes nested files).

Saves results in a structured CSV file.

Prints real-time progress for each folder.