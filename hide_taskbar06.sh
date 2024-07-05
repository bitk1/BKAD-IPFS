#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Backup the original panel configuration
cp /etc/xdg/lxpanel/LXDE-pi/panels/panel /etc/xdg/lxpanel/LXDE-pi/panels/panel.bak

# Modify the panel configuration to hide the taskbar
sed -i 's/autohide=0/autohide=1/' /etc/xdg/lxpanel/LXDE-pi/panels/panel
sed -i 's/heightwhenhidden=2/heightwhenhidden=0/' /etc/xdg/lxpanel/LXDE-pi/panels/panel

# Remove the taskbar plugin
sed -i '/type=taskbar/,/}/d' /etc/xdg/lxpanel/LXDE-pi/panels/panel

echo "Taskbar has been hidden for all users. A backup of the original configuration has been created."
echo "Please restart the X session or reboot the Raspberry Pi for changes to take effect."
