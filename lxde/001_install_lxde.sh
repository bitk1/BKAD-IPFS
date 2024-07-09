#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Update and upgrade the system
echo "Updating system packages..."
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get upgrade -y

# Install LXDE core and lxappearance without any interaction
echo "Installing LXDE core..."
apt-get install -y lxde-core lxappearance

# Set LXDE as the default desktop environment automatically
echo "Setting LXDE as the default desktop environment..."
update-alternatives --set x-session-manager /usr/bin/startlxde

# Optional: Install and configure LXDM as the default display manager without prompts
echo "Installing and configuring LXDM as the display manager..."
apt-get install -y lxdm
echo "/usr/sbin/lxdm" > /etc/X11/default-display-manager

# Cleanup unused packages automatically
apt-get autoremove -y

# Recommend a reboot at the end of the script
echo "Installation complete. It is recommended to reboot your system."
echo "Reboot now? (y/n): "
read response
if [ "$response" == "y" ]; then
    echo "Rebooting now..."
    reboot
else
    echo "Please reboot your system manually to apply changes."
fi
