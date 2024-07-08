#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Automatically configure LXDM to start LXDE session
echo "Configuring LXDM to start LXDE session..."
sed -i 's|^# session=.*|session=/usr/bin/startlxde|' /etc/lxdm/lxdm.conf

# Automatically enable auto-login for user 'bitk1'
echo "Enabling auto-login for user 'bitk1'..."
sed -i 's|^# autologin=.*|autologin=bitk1|' /etc/lxdm/lxdm.conf

# Enable LXDM to start on boot
echo "Enabling LXDM to start on boot..."
systemctl enable lxdm

# Restart LXDM to apply changes
echo "Restarting LXDM to apply changes..."
systemctl restart lxdm

echo "Configuration complete. A system reboot is recommended."
echo "Rebooting now..."
reboot
