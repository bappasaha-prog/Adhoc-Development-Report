Windows Service Extractor

This Python script retrieves a list of all Windows services on a system and saves them into a text file (C:\servicesystem.txt).

It uses the built-in Windows command-line tool sc query to fetch details, extracts only the service names, and stores them for review.

How It Works

The script runs the Windows command:

sc query type= service state= all

This lists all services (running, stopped, or paused).

Using a regular expression, it extracts the lines that contain:

SERVICE_NAME: <ServiceName>

and collects only the <ServiceName>.

It saves the list of service names into:

C:\servicesystem.txt

Prints a success message once the file is created.

Example

Generated File (C:\servicesystem.txt):

AudioEndpointBuilder
Appinfo
BITS
CryptSvc
Dhcp
Dnscache
EventLog
LanmanServer
Spooler
W32Time
...

▶️ How to Run

Open Command Prompt (with admin rights recommended)/exe and run:

python windows_service_extractor.py

Check the generated file at:

C:\servicesystem.txt

✅ Features

Retrieves all Windows services (active & inactive).

Saves clean list of service names only.

Lightweight (uses only built-in subprocess and re modules).

⚠️ Note: This script is designed for Windows only (since it relies on sc query).