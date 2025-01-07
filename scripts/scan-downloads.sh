#!/bin/bash

# Download scanner script
# Monitors download directory for new files and automatically scans them for viruses
# Uses inotifywait for file monitoring and ClamAV for virus scanning
# Assumptions:
# - ClamAV daemon (clamd) is running
# - inotifywait is installed (from inotify-tools package)
# - Appropriate permissions are set for all directories

# configure directories
WATCH_DIR="/path/to/downloads"
LOG_FILE="/var/log/clamav/download-scans.log"
QUARANTINE_DIR="/path/to/quarantine"

# crate quarantine directory if it doesn't exist
mkdir -p "$QUARANTINE_DIR"

# function to to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# function to scan a file
scan_file() {
    local file="$1"
    log_message "Scanning new file: $file"
    
    clamdscan --multiscan "$file" >> "$LOG_FILE" 2>&1
    
    if [ $? -eq 1 ]; then
        log_message "WARNING: Infection found in $file"
        mv "$file" "$QUARANTINE_DIR/"
        log_message "Moved infected file to quarantine"
    fi
}

# check the directory for new files
inotifywait -m -r -e create,moved_to --format '%w%f' "$WATCH_DIR" | while read FILE
do
    scan_file "$FILE"
done
