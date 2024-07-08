#!/bin/bash

# This script needs to run as root to change system settings
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Define where the config file is located
CONFIG_FILE="/home/$SUDO_USER/.config/pcmanfm/LXDE/pcmanfm.conf"

# Set environment variables for graphical commands
export DISPLAY=:0
export XAUTHORITY="/home/$SUDO_USER/.Xauthority"

# Check if the configuration file exists and create if not
if [ ! -f "$CONFIG_FILE" ]; then
    echo "PCManFM configuration file not found. Creating default configuration."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo "[*]" > "$CONFIG_FILE"
    echo "[Desktop]" >> "$CONFIG_FILE"
    echo "show_trash=0" >> "$CONFIG_FILE"
else
    # Update the configuration to hide the wastebasket icon
    if grep -q "show_trash" "$CONFIG_FILE"; then
        sed -i 's/show_trash=.*/show_trash=0/' "$CONFIG_FILE"
    else
        echo "[Desktop]" >> "$CONFIG_FILE"
        echo "show_trash=0" >> "$CONFIG_FILE"
    fi
    echo "Wastebasket icon configuration updated."
fi

# Use pcmanfm to reconfigure the desktop
pcmanfm --reconfigure

echo "Wastebasket icon removed from desktop. Please log out and log back in, or restart to see changes."
