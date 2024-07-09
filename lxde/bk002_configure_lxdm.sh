#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Configure LXDM to start LXDE session
echo "Configuring LXDM to start LXDE session..."
sed -i 's|# session=/usr/bin/startlxde|session=/usr/bin/startlxde|' /etc/lxdm/lxdm.conf

# Option to enable auto-login
read -p "Do you want to enable auto-login? (y/n): " auto_login
if [[ "$auto_login" == "y" || "$auto_login" == "Y" ]]; then
    read -p "Enter the username for auto-login: " username
    sed -i "s|# autologin=dgod|autologin=$username|" /etc/lxdm/lxdm.conf
    echo "Auto-login enabled for user $username."
fi

# Restart LXDM to apply changes
echo "Restarting LXDM to apply changes..."
systemctl restart lxdm

echo "Configuration complete. Please reboot the system to ensure all changes take effect."

# Offer to reboot the system
read -p "Would you like to reboot now? (y/n): " response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    echo "Rebooting now..."
    reboot
else
    echo "Please reboot manually to apply changes."
fi
