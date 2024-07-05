#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Function to backup a file
backup_file() {
    if [ -f "$1" ]; then
        cp "$1" "$1.bak_$(date +%Y%m%d_%H%M%S)"
        echo "Backup created for $1"
    fi
}

# Backup and modify wayfire.ini
WAYFIRE_CONFIG="/home/bitk1/.config/wayfire.ini"
backup_file "$WAYFIRE_CONFIG"

if grep -q "\[panel\]" "$WAYFIRE_CONFIG"; then
    sed -i '/\[panel\]/,/^$/c\[panel]\nautohide = true\nposition = top' "$WAYFIRE_CONFIG"
else
    echo -e "\n[panel]\nautohide = true\nposition = top" >> "$WAYFIRE_CONFIG"
fi

echo "Updated $WAYFIRE_CONFIG"

# Backup and modify wf-panel-pi.ini
PANEL_CONFIG="/home/bitk1/.config/wf-panel-pi.ini"
backup_file "$PANEL_CONFIG"

if grep -q "\[panel\]" "$PANEL_CONFIG"; then
    sed -i '/\[panel\]/,/^$/c\[panel]\nautohide = true\nautohide_duration = 300' "$PANEL_CONFIG"
else
    sed -i '1i[panel]\nautohide = true\nautohide_duration = 300\n' "$PANEL_CONFIG"
fi

echo "Updated $PANEL_CONFIG"

# Check for additional Wayfire configuration files
WAYFIRE_XDG_CONFIG="/etc/xdg/wayfire"
if [ -d "$WAYFIRE_XDG_CONFIG" ]; then
    echo "Additional Wayfire configuration files found in $WAYFIRE_XDG_CONFIG:"
    ls -l "$WAYFIRE_XDG_CONFIG"
    echo "You may need to check these files for panel-related settings."
fi

# Ensure correct ownership of modified files
chown bitk1:bitk1 "$WAYFIRE_CONFIG" "$PANEL_CONFIG"

echo "Configuration files have been updated to auto-hide the panel."
echo "Please reboot your system for changes to take effect."
echo "You can reboot by running: sudo reboot"
