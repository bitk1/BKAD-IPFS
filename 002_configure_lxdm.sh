#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo "Ensuring LXDM service is properly set up..."

# Define the path to the LXDM systemd service file
SERVICE_FILE="/lib/systemd/system/lxdm.service"

# Add missing [Install] section if not present
if ! grep -q "\[Install\]" $SERVICE_FILE; then
    echo "Adding missing [Install] section to LXDM service file..."
    echo -e "\n[Install]\nWantedBy=graphical.target" >> $SERVICE_FILE
fi

# Reload systemd to recognize changes
systemctl daemon-reload

# Enable and start LXDM
systemctl enable lxdm
systemctl restart lxdm

echo "LXDM service has been configured to start at boot."
