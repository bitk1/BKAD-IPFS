#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Fix the LXDM service file
SERVICE_FILE="/lib/systemd/system/lxdm.service"
echo "Correcting the LXDM service file..."

# Move TimeoutStopSec to the correct section
if grep -q "TimeoutStopSec=" $SERVICE_FILE; then
    # Remove existing TimeoutStopSec from wrong place
    sed -i '/TimeoutStopSec=/d' $SERVICE_FILE
    # Add TimeoutStopSec to the [Service] section
    sed -i '/\[Service\]/a TimeoutStopSec=120' $SERVICE_FILE
else
    # Just add TimeoutStopSec under [Service] if it doesn't exist
    sed -i '/\[Service\]/a TimeoutStopSec=120' $SERVICE_FILE
fi

# Reload systemd to recognize changes
echo "Reloading systemd configurations..."
systemctl daemon-reload

# Reinstall gnome keyring and its PAM module
echo "Reinstalling GNOME Keyring and its PAM module..."
apt-get install --reinstall -y gnome-keyring libpam-gnome-keyring

# Restart LXDM to apply changes
echo "Restarting LXDM to apply all changes..."
systemctl restart lxdm

echo "Fixes applied. Please monitor the system for any further issues."
