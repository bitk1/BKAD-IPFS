#!/bin/bash

# Configuration file path
CONFIG_FILE="/home/$USER/.config/pcmanfm/LXDE/pcmanfm.conf"

# Ensure the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file not found, attempting to create it."
  mkdir -p "$(dirname "$CONFIG_FILE")"
  echo "[*]" > "$CONFIG_FILE"
fi

# Update configuration to hide the trash icon
echo "[Desktop]" >> $CONFIG_FILE
echo "show_trash=0" >> $CONFIG_FILE

# Reload PCManFM to apply changes
pcmanfm --reconfigure

echo "Wastebasket icon removed from desktop."
