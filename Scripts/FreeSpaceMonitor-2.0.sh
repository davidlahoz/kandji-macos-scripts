#!/bin/bash
# Created by David L. (https://github.com/davidlahoz)
#
# Free Space monitor and log management script - Uses Kandji CLI
# Replace "ITResources" if ResourceFolder.sh was customized. If not the folder is created (see line 12)
# Checks free space and manages the size of FreeSpace.log - Alert triggered every 48h

# Path to the file that stores the timestamp of the last alert
LAST_ALERT_FILE="/Library/Application Support/ITResources/FreeSpace.log"

# Ensure the directory exists
mkdir -p "/Library/Application Support/ITResources"

#Retrieve storage information from System Information app
storage_info=$(system_profiler SPStorageDataType)

#Extract the value for "Free" using awk
free=$(echo "$storage_info" | awk '/Free:/ {print $2; exit}' | cut -d, -f1)

# Function to check if 48 hours have passed since the last alert
function should_show_alert {
    if [[ -f "$LAST_ALERT_FILE" ]]; then
        last_alert_time=$(cat "$LAST_ALERT_FILE")
        current_time=$(date +%s)
        elapsed_time=$((current_time - last_alert_time))

        # 48 hours in seconds
        if [[ $elapsed_time -ge 172800 ]]; then
            return 0 # True, should show alert
        else
            return 1 # False, should not show alert
        fi
    else
        return 0 # True, should show alert (file does not exist)
    fi
}

#Check if free space is less than 20 GB
if [[ $(echo "$free < 20" | bc -l) -eq 1 ]]; then
    echo "Available space is less than 300GB. Total $free GB"
    
    if should_show_alert; then
        # Alert user via kandji CLI - comment next line to disable alert to user
        sudo /usr/local/bin/kandji display-alert --title "Low Disk Space" --message "There's less than 20GB of free space on your MacBook’s hard drive, which might lead to performance issues. We recommend removing any non-essential files. For additional support, please to reach out to the IT department."
        
        # Update the last alert timestamp
        date +%s > "$LAST_ALERT_FILE"
    fi

    exit 1
else
    echo "Enough free space on system. Total $free GB."
    exit 0
fi

# Log file management
# Check if the log file exists and its size
if [[ -f "$LAST_ALERT_FILE" ]]; then
    # Get the size of the file in bytes
    file_size=$(stat -f%z "$LAST_ALERT_FILE")

    # Size limit (2MB in bytes)
    size_limit=$((2 * 1024 * 1024))

    # Compare the file size with the limit
    if [[ file_size -gt size_limit ]]; then
        echo "FreeSpace.log exceeded 2MB. Deleting file..."
        rm "$LAST_ALERT_FILE"

        # Optional: Create a new, empty log file
        # touch "$LAST_ALERT_FILE"
    fi
fi