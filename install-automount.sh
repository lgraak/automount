#!/bin/bash

set -e

SCRIPT_PATH="/usr/local/bin/mount-check.sh"
SERVICE_PATH="/etc/systemd/system/mount-check.service"
TIMER_PATH="/etc/systemd/system/mount-check.timer"
FSTAB_FILE="/etc/fstab"
FSTAB_ENTRY="//jedi-archive.ad.cgillett.com/Media /mnt/Media cifs credentials=/etc/smbcreds,uid=0,iocharset=utf8,vers=3.0,noperm,nofail,x-systemd.automount 0 0"

echo "🔧 Installing mount-check script to $SCRIPT_PATH..."
sudo cp mount-check.sh "$SCRIPT_PATH"
sudo chmod +x "$SCRIPT_PATH"

echo "🔧 Installing systemd service and timer..."
sudo cp mount-check.service "$SERVICE_PATH"
sudo cp mount-check.timer "$TIMER_PATH"

echo "🔄 Reloading systemd..."
sudo systemctl daemon-reload

echo "✅ Enabling and starting the mount-check timer..."
sudo systemctl enable --now mount-check.timer

# Add fstab entry if it doesn't already exist
if grep -Fxq "$FSTAB_ENTRY" "$FSTAB_FILE"; then
    echo "ℹ️  fstab entry already exists. Skipping."
else
    echo "📝 Backing up fstab to /etc/fstab.bak..."
    sudo cp "$FSTAB_FILE" "${FSTAB_FILE}.bak"

    echo "➕ Adding fstab entry for /mnt/Media..."
    echo "$FSTAB_ENTRY" | sudo tee -a "$FSTAB_FILE" > /dev/null
fi

echo "🚀 Setup complete! The CIFS share will mount automatically and be monitored every 10 minutes."
