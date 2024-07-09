#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Environment setup for GUI operations
export DISPLAY=:0
XAUTHORITY="/home/$SUDO_USER/.Xauthority"
export XAUTHORITY

echo "Using Xauthority at $XAUTHORITY"
echo "Config file used: $CONFIG_FILE"

CONFIG_FILE="/home/$SUDO_USER/.config/pcmanfm/LXDE/pcmanfm.conf"

# Check if the configuration file exists or create if not
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found. Attempting to create default configuration."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo "[Desktop]" > "$CONFIG_FILE"
    echo "show_trash=0" >> "$CONFIG_FILE"
else
    echo "Updating existing configuration file to hide trash icon..."
    grep -q "show_trash" "$CONFIG_FILE" && sed -i 's/show_trash=.*/show_trash=0/' "$CONFIG_FILE" || echo "show_trash=0" >> "$CONFIG_FILE"
fi

# Force reload the PCManFM configuration to apply changes
echo "Attempting to reconfigure PCManFM..."
killall pcmanfm
pcmanfm --desktop --profile LXDE &

echo "Operation completed."
