#!/bin/bash
# Created by David L. (https://github.com/davidlahoz)
#
# Script to modify /private/etc/pam.d/sudo and manage backups.
# Also copies the file backup to the "ITResources" folder created with ResourceFolder.sh
# Replace "ITResources" if ResourceFolder.sh was customized. If nto the folder is created (see line 12)

FILE_PATH="/private/etc/pam.d/sudo"
NEW_LINE="auth sufficient pam_tid.so"
TEMP_FILE="/tmp/sudo_pam_temp"
BACKUP_FILE="$FILE_PATH.backup"
RESOURCE_BACKUP_DIR="/Library/Application Support/ITResources"
RESOURCE_BACKUP_FILE="$RESOURCE_BACKUP_DIR/$(basename $FILE_PATH).backup"

# Ensure the script is run with superuser privileges
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Check if the file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "File $FILE_PATH does not exist."
    exit 1
fi

# Create the RESOURCE backup directory if it doesn't exist
mkdir -p "$RESOURCE_BACKUP_DIR"

# Create a backup if it doesn't already exist
if [ ! -f "$BACKUP_FILE" ]; then
    cp "$FILE_PATH" "$BACKUP_FILE"
    echo "Backup created at $BACKUP_FILE."

    # Copy the backup to the RESOURCE directory
    cp "$BACKUP_FILE" "$RESOURCE_BACKUP_FILE"
    echo "Backup copied to $RESOURCE_BACKUP_FILE."
else
    echo "Backup already exists at $BACKUP_FILE. No new backup created."

    # Ensure the RESOURCE backup also exists
    if [ ! -f "$RESOURCE_BACKUP_FILE" ]; then
        cp "$BACKUP_FILE" "$RESOURCE_BACKUP_FILE"
        echo "Backup copied to $RESOURCE_BACKUP_FILE."
    else
        echo "ITResources backup already exists at $RESOURCE_BACKUP_FILE. No new copy created."
    fi
fi

# Insert the new line at the second line of the file
awk -v newline="$NEW_LINE" 'NR==2{print newline}1' "$FILE_PATH" > "$TEMP_FILE"

# Replace the original file with the modified one
mv "$TEMP_FILE" "$FILE_PATH"

# Optional: Remove the temporary file (if you want to inspect it, you can leave this commented)
# rm "$TEMP_FILE"

echo "Modification complete."