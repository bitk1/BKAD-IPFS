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

# Remove any existing panel configuration
sed -i '/\[panel\]/,/^$/d' "$WAYFIRE_CONFIG"

# Add panel plugin to the plugins.unload list
if grep -q "plugins.unload" "$WAYFIRE_CONFIG"; then
    sed -i '/plugins.unload/s/$/, panel/' "$WAYFIRE_CONFIG"
else
    echo "plugins.unload = panel" >> "$WAYFIRE_CONFIG"
fi

echo "Updated $WAYFIRE_CONFIG"

# Backup wf-panel-pi.ini
PANEL_CONFIG="/home/bitk1/.config/wf-panel-pi.ini"
backup_file "$PANEL_CONFIG"

# Rename wf-panel-pi.ini to disable it
mv "$PANEL_CONFIG" "${PANEL_CONFIG}.disabled"
echo "Disabled $PANEL_CONFIG"

# Check for and modify system-wide Wayfire configuration
WAYFIRE_SYS_CONFIG="/etc/wayfire.ini"
if [ -f "$WAYFIRE_SYS_CONFIG" ]; then
    backup_file "$WAYFIRE_SYS_CONFIG"
    
    # Remove any existing panel configuration
    sed -i '/\[panel\]/,/^$/d' "$WAYFIRE_SYS_CONFIG"
    
    # Add panel plugin to the plugins.unload list
    if grep -q "plugins.unload" "$WAYFIRE_SYS_CONFIG"; then
        sed -i '/plugins.unload/s/$/, panel/' "$WAYFIRE_SYS_CONFIG"
    else
        echo "plugins.unload = panel" >> "$WAYFIRE_SYS_CONFIG"
    fi
    
    echo "Updated $WAYFIRE_SYS_CONFIG"
fi

# Ensure correct ownership of modified files
chown bitk1:bitk1 "$WAYFIRE_CONFIG"
[ -f "$WAYFIRE_SYS_CONFIG" ] && chown root:root "$WAYFIRE_SYS_CONFIG"

echo "Configuration files have been updated to disable the panel."
echo "Please reboot your system for changes to take effect."
echo "You can reboot by running: sudo reboot"
