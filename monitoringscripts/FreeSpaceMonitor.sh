#!/bin/bash
# Free Space monitor script
# Created by David L.
#
# Description:
# Retrieve free space from device. If the space is < X, it will show as an alert on Kandji (exit 1). 
# If > X it will not pop up as alert (exit 0) but will be available on the device detailed view
# It also warns the user with an alert using Kandji CLI


#Retrieve storage information from System Information app
storage_info=$(system_profiler SPStorageDataType)

#Extract the value for "Free" using awk
free=$(echo "$storage_info" | awk '/Free:/ {print $2; exit}' | cut -d, -f1)

#Check if free space is less than 20 GB
if [[ $(echo "$free < 20" | bc -l) -eq 1 ]]; then
    echo "Available space is less than 20GB. Total $free GB"
    
# Alert user via kandji CLI - comment next line to disable alert to user
sudo /usr/local/bin/kandji display-alert --title "Low Disk Space" --message "Your Macbook's Hard Drive is running low on space (< 20GB free).  This might cause performance issues. Please delete some unnecessary files if possible. For further assistance contact IT ."
    exit 1
else
    echo "Enough free space on system. Total $free GB."
    exit 0
fi
