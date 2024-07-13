#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo "Starting full setup..."

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
echo "A reboot is recommended to apply all changes effectively."

# Offer to reboot
echo "Do you want to reboot now? (y/n): "
read response
if [ "$response" == "y" ]; then
    echo "Rebooting now..."
    reboot
else
    echo "Please reboot your system manually to apply changes."
fi
