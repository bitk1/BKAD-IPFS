#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
   echo "Please run as root" 1>&2
   exit 1
fi

# Disable screen blanking in the X server
xset s off -dpms

# Add these commands to the LXDE autostart to make the changes persistent across reboots
AUTOSTART_DIR="/etc/xdg/lxsession/LXDE-pi/autostart"

# Check if the directory exists
if [ ! -d "$AUTOSTART_DIR" ]; then
    echo "$AUTOSTART_DIR does not exist, creating..."
    mkdir -p "$AUTOSTART_DIR"
fi

# Add commands to autostart
echo "@xset s off" >> "$AUTOSTART_DIR/autostart"
echo "@xset -dpms" >> "$AUTOSTART_DIR/autostart"

echo "Screen timeout disabled. Changes will apply on next reboot."

# Optional: Configure LXDE power manager settings if LXDE power manager is used
# Uncomment the following lines if LXDE power manager is part of your setup
# POWER_MANAGER_CONF="/etc/xdg/xfce4/power-manager/xfce4-power-manager.xml"
# if [ -f "$POWER_MANAGER_CONF" ]; then
#     echo "Configuring LXDE power manager..."
#     xmlstarlet ed -L -u "/channel/property[@name='dpms_enabled']/@value" -v "false" "$POWER_MANAGER_CONF"
#     echo "Power management settings updated."
# else
#     echo "LXDE power manager configuration file not found. Skipping power management configuration."
# fi
