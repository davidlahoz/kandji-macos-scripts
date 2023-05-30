#!/bin/bash
# Free Space monitor script
# Created by David L.
#
# Description:
# Retrieve free space from device. If the space is < X, it will show as an alert on Kandji (exit 1).
# If > X it will not pop up as alert (exit 0) but will be available on the device detailed view
#

#Retrieve storage information from System Information app
storage_info=$(system_profiler SPStorageDataType)

#Extract the value for "Free" using awk
free=$(echo "$storage_info" | awk '/Free:/ {print $2; exit}' | cut -d, -f1)

#Check if free space is less than 20 GB
if [[ $(echo "$free < 20" | bc -l) -eq 1 ]]; then
    echo "Available space is less than 20GB. Total $free GB"
    exit 1
else
    echo "Enough free space on system. Total $free GB."
    exit 0
fi
