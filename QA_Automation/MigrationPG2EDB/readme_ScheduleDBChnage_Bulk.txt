Working of the Script

This Python script is used to update XML files for multiple clients based on connection details provided in a CSV file (client.csv).

1. Input Setup

The script asks you to enter the base folder path where all client folders and client.csv files are stored.

Inside this base folder:

There must be a file called client.csv.

Each client must have a folder named after them, containing a working subfolder with XML files.

2. CSV File (client.csv)

The script expects the CSV file to have these columns:

name → client’s folder name

dataconnstr → new value to update <dataconnstr> tag

ConnectionString → new value to update <option name="ConnectionString" />

Example client.csv:

name,dataconnstr,ConnectionString
ClientA,DataSource=server1;Database=dbA,Server=server1;Database=dbA;User Id=sa;Password=pass;
ClientB,DataSource=server2;Database=dbB,Server=server2;Database=dbB;User Id=sa;Password=pass;

3. XML Update Logic

For each client:

Go to base_folder/<client_name>/working/.

For every .xml file:

Look for <dataconnstr> tag → update its text with the new value from CSV.

Look for <option name="ConnectionString" /> → update its value attribute.

Save the updated XML file.

-If either tag is found and updated → file is rewritten with new values.
-If no matching tags found → script warns you.
-If XML parsing or file error occurs → script logs the error.

4. Processing Example

Suppose inside ClientA/working/report.xml you have:

<config>
  <dataconnstr>old_value</dataconnstr>
  <option name="ConnectionString" value="old_conn" />
</config>


After running the script (using ClientA’s details from client.csv), it will become:

<config>
  <dataconnstr>DataSource=server1;Database=dbA</dataconnstr>
  <option name="ConnectionString" value="Server=server1;Database=dbA;User Id=sa;Password=pass;" />
</config>