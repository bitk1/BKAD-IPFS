#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Use the current user's home directory for configuration files
CONFIG_FILE="/home/$SUDO_USER/.config/pcmanfm/LXDE/pcmanfm.conf"

# Ensure the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  mkdir -p "$(dirname "$CONFIG_FILE")"
  echo "[*]" > "$CONFIG_FILE"
fi

# Update configuration to hide the trash icon
echo "[Desktop]" >> $CONFIG_FILE
echo "show_trash=0" >> $CONFIG_FILE

echo "Wastebasket icon removed from desktop."

# Attempt to reload the desktop configuration
export DISPLAY=:0
export XAUTHORITY="/home/$SUDO_USER/.Xauthority"
pcmanfm --reconfigure
