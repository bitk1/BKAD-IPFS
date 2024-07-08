#!/bin/bash

# Check if running as root
if [ "$(id -u)" != "0" ]; then
  echo "Please run as root"
  exit
fi

# Configuration file path
config_file="/etc/xdg/pcmanfm/LXDE/desktop-items-0.conf"

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

# Attempt to reload the desktop configuration immediately
export DISPLAY=:0
export XAUTHORITY=~/.Xauthority
pcmanfm --reconfigure
