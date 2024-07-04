#!/bin/bash

echo "Starting full cleanup of BKAD-IPFS installation..."

# Stop and disable IPFS and IPFS Cluster services if they are running
echo "Stopping and disabling IPFS and IPFS Cluster services..."
sudo systemctl stop ipfs.service ipfs-cluster.service auto_pin_external.service auto_pin_subnet.timer || true
sudo systemctl disable ipfs.service ipfs-cluster.service auto_pin_external.service auto_pin_subnet.timer || true
sudo pkill -f ipfs || true
sudo pkill -f ipfs-cluster || true

# Remove systemd service files
echo "Removing systemd service files..."
sudo rm -f /etc/systemd/system/ipfs.service
sudo rm -f /etc/systemd/system/ipfs-cluster.service
sudo rm -f /etc/systemd/system/auto_pin_external.service
sudo rm -f /etc/systemd/system/auto_pin_subnet.service
sudo rm -f /etc/systemd/system/auto_pin_subnet.timer

# Reload systemd to apply changes
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Remove IPFS and IPFS Cluster binaries and configurations
echo "Removing IPFS and IPFS Cluster binaries and configurations..."
sudo rm -rf /usr/local/bin/ipfs
sudo rm -rf /usr/local/bin/ipfs-cluster-service
sudo rm -rf /usr/local/bin/ipfs-cluster-ctl
sudo rm -rf /home/bitk1/.ipfs
sudo rm -rf /home/bitk1/.ipfs-cluster

# Remove any additional scripts
echo "Removing additional scripts..."
sudo rm -f /usr/local/bin/auto_pin_external.sh
sudo rm -f /usr/local/bin/auto_pin_subnet.sh

# Remove desktop shortcut and wallpaper settings
echo "Removing desktop shortcuts and resetting desktop configuration..."
sudo rm -f /home/bitk1/Desktop/ipfs-webui.desktop
sudo rm -f /home/bitk1/bk_circle_300.png
sudo rm -f /home/bitk1/bk_reverse.png
if [ -d "/home/bitk1/.config/pcmanfm/LXDE/" ]; then
    sudo rm -f /home/bitk1/.config/pcmanfm/LXDE/desktop-items-0.conf
    sudo pcmanfm --reconfigure
fi

# Clean up any remaining package dependencies that are no longer needed
echo "Removing unused packages..."
sudo apt autoremove -y

echo "Uninstallation complete. The system is now clean and ready for a fresh installation."
