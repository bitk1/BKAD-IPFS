#!/bin/bash

set -e

# Stop IPFS and IPFS Cluster services if they are running
echo "Stopping IPFS and IPFS Cluster services if they are running..."
sudo systemctl stop ipfs || true
sudo systemctl disable ipfs || true
sudo systemctl stop ipfs-cluster || true
sudo systemctl disable ipfs-cluster || true

# Remove IPFS service files
echo "Removing IPFS service files..."
sudo rm -f /etc/systemd/system/ipfs.service
sudo rm -f /etc/systemd/system/ipfs-cluster.service

# Reload systemd to apply changes
echo "Reloading systemd..."
sudo systemctl daemon-reload

# Kill any remaining IPFS processes
echo "Killing any remaining IPFS processes..."
sudo pkill -f ipfs || true
sudo pkill -f ipfs-cluster || true

# Remove IPFS and IPFS Cluster binaries
echo "Removing IPFS and IPFS Cluster binaries..."
sudo rm -f /usr/local/bin/ipfs
sudo rm -f /usr/local/bin/ipfs-cluster-service
sudo rm -f /usr/local/bin/ipfs-cluster-ctl

# Remove IPFS and IPFS Cluster configuration directories
echo "Removing IPFS and IPFS Cluster configuration directories..."
sudo rm -rf /home/bitk1/.ipfs
sudo rm -rf /home/bitk1/.ipfs-cluster

# Remove auto pinning scripts and services
echo "Removing auto pinning scripts and services..."
sudo rm -f /usr/local/bin/auto_pin_external.sh
sudo rm -f /usr/local/bin/auto_pin_subnet.sh
sudo rm -f /etc/systemd/system/auto_pin_external.service
sudo rm -f /etc/systemd/system/auto_pin_subnet.service
sudo rm -f /etc/systemd/system/auto_pin_subnet.timer

# Reload systemd to apply changes
echo "Reloading systemd again..."
sudo systemctl daemon-reload

# Remove desktop shortcut and wallpaper settings
echo "Removing desktop shortcut and wallpaper settings..."
sudo rm -f /home/bitk1/Desktop/ipfs-webui.desktop
sudo rm -f /home/bitk1/.config/pcmanfm/LXDE/desktop-items-0.conf

echo "Uninstallation complete. The system is clean and ready for a fresh installation."
