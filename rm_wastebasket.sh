#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "Please run as root"
  exit
fi

# Path to the PCManFM configuration file for the LXDE environment
CONFIG_FILE="/home/$USER/.config/pcmanfm/LXDE/pcmanfm.conf"

# Ensure the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Configuration file not found, attempting to create it."
  mkdir -p "$(dirname "$CONFIG_FILE")"
  echo "[*]" > "$CONFIG_FILE"
fi

# Check if 'show_trash' option is already set and modify it
if grep -q "show_trash" "$CONFIG_FILE"; then
  sed -i 's/show_trash=1/show_trash=0/' "$CONFIG_FILE"
else
  echo "show_trash=0" >> "$CONFIG_FILE"
fi

echo "Wastebasket icon removed from desktop."

# Reload PCManFM to apply changes
if pgrep pcmanfm; then
  pcmanfm --reconfigure
fi

echo "You may need to log out and log back in, or restart the Pi to see the changes."
