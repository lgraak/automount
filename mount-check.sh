#!/bin/bash

MOUNT_POINT="/mnt/Media"
LOG_FILE="/var/log/mount-check.log"

if ! mountpoint -q "$MOUNT_POINT"; then
    echo "$(date) - $MOUNT_POINT is not mounted. Attempting to remount..." >> "$LOG_FILE"
    mount "$MOUNT_POINT" >> "$LOG_FILE" 2>&1
else
    echo "$(date) - $MOUNT_POINT is OK." >> "$LOG_FILE"
fi
