import subprocess
import re

# Output file location
OUTPUT_FILE = r"c:\\servicesystem.txt"

def get_services():
    """Fetch all Windows service names and return them as a list."""
    try:
        # Run 'sc query' to get all services
        result = subprocess.run(["sc", "query", "type=", "service", "state=", "all"], capture_output=True, text=True)
        
        # Extract only the service names
        services = re.findall(r"SERVICE_NAME:\s+(\S+)", result.stdout)
        return services
    except Exception as e:
        print(f"Error fetching services: {e}")
        return []

def save_services_to_file(services):
    """Save service names to C:\servicesystem.txt."""
    try:
        with open(OUTPUT_FILE, "w") as file:
            for service in services:
                file.write(service + "\n")
        print(f"Service list saved to {OUTPUT_FILE}")
    except Exception as e:
        print(f"Error writing to file: {e}")

def main():
    services = get_services()
    if services:
        save_services_to_file(services)
    else:
        print("No services found.")

if __name__ == "__main__":
    main()
