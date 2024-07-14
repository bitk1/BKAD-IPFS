#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Define username
username="bitk1"  # Update this if the script needs to run for a different user

# Path to the system-wide LXDE configuration file
config_file="/etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf"

# Backup the original configuration
cp "$config_file" "${config_file}.bak"

# Check if show_trash is already set
if grep -q "show_trash=" "$config_file"; then
    # If it exists, update it
    sed -i 's/show_trash=.*/show_trash=0/' "$config_file"
else
    # If it doesn't exist, add it
    echo "show_trash=0" >> "$config_file"
fi

echo "Wastebasket icon removed from desktop."
echo "You may need to log out and log back in, or restart the Pi to see the changes."

# Attempt to reload the desktop configuration immediately
DISPLAY=:0 pcmanfm --reconfigure 2>/dev/null || echo "Failed to reconfigure pcmanfm, please reconfigure manually."
