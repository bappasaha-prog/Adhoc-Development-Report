This one is used to start services which were stopped by bat file 1

@echo off

Hides the commands themselves in the console, showing only results.

net start <ServiceName>

Starts a Windows service with the given name.

Example:

net start Scheduler_AHHO_21053


This tries to start the service named Scheduler_AHHO_21053.

The script goes through a list of many services (Scheduler_...) and attempts to start each one.

pause

Keeps the Command Prompt window open after execution, so the user can see messages like:

"The service was started successfully."

"The requested service has already been started."

Or error messages if the service doesn’t exist.