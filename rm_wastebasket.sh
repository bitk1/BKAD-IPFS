#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

echo "Setting up environment variables..."
export DISPLAY=:0
export XAUTHORITY="/home/$SUDO_USER/.Xauthority"

CONFIG_FILE="/home/$SUDO_USER/.config/pcmanfm/LXDE/pcmanfm.conf"
echo "Config file used: $CONFIG_FILE"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found. Attempting to create default configuration."
    mkdir -p "$(dirname "$CONFIG_FILE")"
    echo "[*]" > "$CONFIG_FILE"
    echo "[Desktop]" >> "$CONFIG_FILE"
    echo "show_trash=0" >> "$CONFIG_FILE"
else
    echo "Updating existing configuration file to hide trash icon..."
    if grep -q "show_trash" "$CONFIG_FILE"; then
        sed -i 's/show_trash=.*/show_trash=0/' "$CONFIG_FILE"
    else
        echo "[Desktop]" >> "$CONFIG_FILE"
        echo "show_trash=0" >> "$CONFIG_FILE"
    fi
fi

echo "Attempting to reconfigure PCManFM..."
pcmanfm --reconfigure
echo "Operation completed."
