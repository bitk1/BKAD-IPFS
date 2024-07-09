#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Updating LXDM service configuration to increase timeout..."
# Increase TimeoutStopSec for LXDM
SERVICE_FILE="/lib/systemd/system/lxdm.service"
if grep -q "TimeoutStopSec" $SERVICE_FILE; then
    sed -i 's/TimeoutStopSec=.*/TimeoutStopSec=120/' $SERVICE_FILE
else
    echo "TimeoutStopSec=120" >> $SERVICE_FILE
fi

echo "Installing GNOME Keyring and configuring PAM..."
# Install GNOME Keyring and its PAM module
apt-get install -y gnome-keyring libpam-gnome-keyring

# Configure PAM for LXDM
PAM_LXDM="/etc/pam.d/lxdm"
if ! grep -q "pam_gnome_keyring.so" $PAM_LXDM; then
    echo "auth    optional    pam_gnome_keyring.so" >> $PAM_LXDM
    echo "session optional    pam_gnome_keyring.so auto_start" >> $PAM_LXDM
fi

echo "Reloading system daemons and restarting LXDM..."
# Reload systemd to apply changes and restart LXDM
systemctl daemon-reload
systemctl restart lxdm

echo "All modifications applied. Please monitor LXDM for any further issues."
