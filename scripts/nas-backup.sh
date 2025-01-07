#!/bin/bash

# NAS backup script
# Performs an incremental backup of the NAS drive to a backup drive
# Uses rsync with archive mode and deletion of removed files
# Assumptions:
# - Main NAS is mounted at /path/to/nas
# - Backup drive is mounted at /path/to/backup
# - Logs are stored on the backup drive

# get current timestamp for logging
DATE=$(date +%Y-%m-%d_%H-%M-%S)

# perform backup using rsync
rsync -av --delete /path/to/nas/ /path/to/backup/nas_backup/ 2>&1 | tee -a /path/to/backup/backup.log

# log completion time
echo "Backup completed on $DATE" >> /path/to/backup/backup.log
