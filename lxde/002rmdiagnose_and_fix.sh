#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Diagnosing system issues..."

# Checking LXDM Service Status
echo "Checking LXDM Service Status..."
systemctl status lxdm

# Checking for errors in LXDM logs
echo "Recent LXDM logs:"
journalctl -u lxdm --since "1 day ago" | grep -i error

# Check if the TimeoutStopSec is correctly placed in the LXDM service file
SERVICE_FILE="/lib/systemd/system/lxdm.service"
echo "Checking for TimeoutStopSec in the wrong section..."
if grep -q "TimeoutStopSec" $SERVICE_FILE; then
    echo "TimeoutStopSec found in the service file, ensuring it's in the correct section..."
    sed -i '/\[Install\]/,/^\[/{//!d}' $SERVICE_FILE
    sed -i '/^\[Service\]$/a TimeoutStopSec=120' $SERVICE_FILE
    echo "Corrected the LXDM service file."
else
    echo "No misplaced TimeoutStopSec found."
fi

# Reinstall LXDM to fix any broken configurations
echo "Reinstalling LXDM..."
apt-get install --reinstall -y lxdm

# Restart LXDM service
echo "Restarting LXDM service..."
systemctl restart lxdm

# Check for hanging processes related to rm_wastebasket.sh
echo "Checking for hanging rm_wastebasket processes..."
pgrep -a bash | grep rm_wastebasket.sh

# Attempt to kill any hanging rm_wastebasket.sh scripts
pkill -f rm_wastebasket.sh

echo "Diagnostic and fix script completed."
