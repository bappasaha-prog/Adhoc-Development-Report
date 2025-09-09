# README – XML Data Extraction Script

## Purpose
This script extracts specific values from multiple `eWebReportsScheduler.xml` files located inside client folders, and saves the extracted details into a single CSV file (`shudderdetails.csv`).  

It is useful when you have many client folders and want to collect XML settings (SMTP, ports, logging configs, etc.) into one consolidated file.

---

## What You Need to Do (Before Running)

1. **Prepare a base directory**  
   - Create a folder that will act as the *base directory*.  
   - Inside it, you should have:  
     - A file named **`clientname.txt`**  
     - Subfolders for each client (with their XML files inside).  

   Example folder structure:
   ```
   C:\Project\
       clientname.txt
       CLIENT_A\
           eWebReportsScheduler.xml
       CLIENT_B\
           eWebReportsScheduler.xml
       CLIENT_C\
           eWebReportsScheduler.xml
   ```

2. **Fill `clientname.txt`**  
   - Each line should contain **one client folder name**.  
   - Example:
     ```
     CLIENT_A
     CLIENT_B
     CLIENT_C
     ```

3. **Ensure each client folder contains `eWebReportsScheduler.xml`**  
   - The script expects the XML file to be inside each listed folder.  
   - Example path:
     ```
     C:\Project\CLIENT_A\eWebReportsScheduler.xml
     ```

---

## How to Run

1. Open a terminal / command prompt.  
2. Run the script:  
   ```bash
   python extract_xml_to_csv.py
   ```
3. Enter the base directory path when prompted:  
   ```
   Enter the base directory path: C:\Project
   ```

---

## What the Script Does

1. Reads `clientname.txt` from the base directory.  
2. For each folder listed:
   - Looks for `eWebReportsScheduler.xml`.  
   - Extracts the following tags:
     ```
     smtp_server, smtp_enable_ssl, smtp_user_id, smtp_password,
     smtp_from, smtp_from_name, error_report_to, channel_type,
     port, working_directory, default_job_timeout, sleep_time,
     simultaneous_job_max, logging, flush_time, sync_flush_time,
     email_addendum, external_interface, report_path,
     abend_upon_report_error, ip_address, security_protocol,
     encrypt_schedule_files, max_temp_file_age, email_retry_time,
     queue_service
     ```
   - If a tag is missing → writes `"N/A"`.  
3. Writes all extracted data into **`shudderdetails.csv`** in the base directory.  

---

## Example

### Example XML (`CLIENT_A\eWebReportsScheduler.xml`)
```xml
<root>
    <smtp_server>mail.example.com</smtp_server>
    <smtp_enable_ssl>true</smtp_enable_ssl>
    <port>587</port>
</root>
```

### Example `clientname.txt`
```
CLIENT_A
CLIENT_B
```

### Output `shudderdetails.csv`
```
Folder,smtp_server,smtp_enable_ssl,smtp_user_id,...,queue_service
CLIENT_A,mail.example.com,true,N/A,...,N/A
CLIENT_B,N/A,N/A,N/A,...,N/A
```

---

## Summary
- You provide a **base folder** with `clientname.txt` and client subfolders.  
- The script scans each client’s XML.  
- It generates a CSV report with all required tag values.  
