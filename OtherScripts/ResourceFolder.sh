#!/bin/bash
# Replace "ITResources" to anything of your choice

# Create the ITResources folder
sudo mkdir -p "/Library/Application Support/ITResources"

# Set the correct permissions
sudo chmod -R 777 "/Library/Application Support/ITResources"

# Verify if the permissions were set successfully
if [ -r "/Library/Application Support/ITResources" ] && [ -w "/Library/Application Support/ITResources" ]; then
    echo "ITResources folder created and permissions set successfully."
    exit 0
else
    echo "Failed to create ITResources folder or set permissions."
    exit 1
fi