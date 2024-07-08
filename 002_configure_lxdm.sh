#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Configuring LXDM to start LXDE session..."
sed -i 's|^# session=.*|session=/usr/bin/startlxde-pi|' /etc/lxdm/lxdm.conf
sed -i 's|^# autologin=.*|autologin=bitk1|' /etc/lxdm/lxdm.conf

echo "Setting LXDE as the default session manager..."
update-alternatives --set x-session-manager /usr/bin/startlxde-pi

echo "Reloading and restarting LXDM service..."
systemctl daemon-reload
systemctl enable lxdm
systemctl restart lxdm

echo "LXDM configuration complete. A system reboot is recommended."
