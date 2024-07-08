#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Set the display and authorization for X server access
export DISPLAY=:0
export XAUTHORITY=/home/$SUDO_USER/.Xauthority

# Configuration file path for the current user
CONFIG_FILE="/home/$SUDO_USER/.config/pcmanfm/LXDE/pcmanfm.conf"

# Ensure the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file not found, attempting to create it."
  mkdir -p "$(dirname "$CONFIG_FILE")"
  touch "$CONFIG_FILE"
fi

# Update configuration to hide the trash icon
if grep -q "show_trash" "$CONFIG_FILE"; then
    sed -i 's/show_trash=.*/show_trash=0/' "$CONFIG_FILE"
else
    echo "[Desktop]" >> "$CONFIG_FILE"
    echo "show_trash=0" >> "$CONFIG_FILE"
fi

# Attempt to reload the desktop configuration
pcmanfm --reconfigure

echo "Wastebasket icon removed from desktop."
