#!/bin/bash

# Script to install LXDE on Raspberry Pi

echo "Updating system packages..."
sudo apt update
sudo apt upgrade -y

echo "Select the LXDE installation type:"
echo "  1) Full LXDE installation"
echo "  2) Minimal LXDE core installation"
read -p "Enter your choice (1 or 2): " choice

case $choice in
    1)
        echo "Installing full LXDE environment..."
        sudo apt install lxde -y
        ;;
    2)
        echo "Installing LXDE core..."
        sudo apt install lxde-core lxappearance -y
        ;;
    *)
        echo "Invalid input. Exiting."
        exit 1
        ;;
esac

# Set LXDE as the default desktop environment
echo "Setting LXDE as the default desktop environment..."
sudo update-alternatives --config x-session-manager

# Optional LXDM installation
read -p "Do you want to install and use LXDM as your display manager? (y/n): " lxdm_choice
if [[ "$lxdm_choice" == "y" || "$lxdm_choice" == "Y" ]]; then
    echo "Installing LXDM and setting it as the display manager..."
    sudo apt install lxdm -y
    sudo dpkg-reconfigure lxdm
else
    echo "Skipping LXDM installation."
fi

echo "Installation complete. It is recommended to reboot your system."
read -p "Would you like to reboot now? (y/n): " reboot_choice
if [[ "$reboot_choice" == "y" || "$reboot_choice" == "Y" ]]; then
    echo "Rebooting now..."
    sudo reboot
else
    echo "Please reboot your system manually to apply changes."
fi
