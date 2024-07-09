#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
   echo "Please run as root" 1>&2
   exit 1
fi

# Set the display and authorization for X server access
export DISPLAY=:0
export XAUTHORITY=/home/$SUDO_USER/.Xauthority

# Disable screen blanking in the X server
xset s off -dpms

# Add these commands to the LXDE autostart to make the changes persistent across reboots
AUTOSTART_FILE="/etc/xdg/lxsession/LXDE-pi/autostart"

# Check if the autostart file exists, if not, create it
if [ ! -f "$AUTOSTART_FILE" ]; then
    echo "Autostart file does not exist, creating..."
    touch "$AUTOSTART_FILE"
fi

# Add commands to autostart
echo "@xset s off" >> "$AUTOSTART_FILE"
echo "@xset -dpms" >> "$AUTOSTART_FILE"

echo "Screen timeout disabled. Changes will apply on next reboot."
