#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Prevent the script from running multiple times
if pidof -o %PPID -x "$0"; then
   echo "This script is already running."
   exit 1
fi

echo "Starting full setup..."

# Update and upgrade system packages
echo "Updating and upgrading system packages..."
apt update && apt upgrade -y
if [ $? -ne 0 ]; then
    echo "Update or upgrade failed, stopping script to avoid potential issues."
    exit 1
fi

# Setup the runtime directory
echo "Setting up runtime directory..."
source ./setup_runtime_dir.sh

# Run each script in order
echo "Running shortcut setup..."
./shortcut.sh

echo "Changing splash screen..."
./change_splash.sh

echo "Updating wallpaper..."
./wallpaper03.sh

echo "Removing wastebasket icon..."
./rm_wastebasket02.sh

echo "Configuring taskbar..."
./taskbar.sh

echo "Setting up IPFS..."
./034setup_ipfs.sh

echo "Configuring Waybar..."
./bar.sh

echo "All configurations applied successfully!"

# Offer to reboot
echo "It is recommended to reboot your system now to apply all changes effectively. Would you like to reboot now? (y/n): "
read response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    echo "Rebooting now..."
    reboot
else
    echo "Please reboot your system manually to apply changes."
fi
