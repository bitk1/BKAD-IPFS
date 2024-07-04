#!/bin/bash
// v02
echo "Starting full cleanup of BKAD-IPFS installation..."

# Stop and disable IPFS and any related services
echo "Stopping and disabling IPFS services..."
sudo systemctl stop ipfs.service || echo "IPFS service not active."
sudo systemctl disable ipfs.service || echo "IPFS service not enabled."
sudo systemctl daemon-reload  # Reload systemd to apply changes

# Kill any remaining IPFS processes
echo "Killing any remaining IPFS processes..."
sudo pkill -f ipfs || echo "No IPFS processes were running."

# Remove IPFS binaries, configuration, and service files
echo "Removing IPFS binaries and configuration..."
sudo rm -rf /usr/local/bin/ipfs
sudo rm -rf /home/bitk1/.ipfs  # Remove IPFS configuration directory

# Check and remove systemd service files if they exist
echo "Removing IPFS systemd service files..."
if [ -f "/etc/systemd/system/ipfs.service" ]; then
    sudo rm /etc/systemd/system/ipfs.service
    echo "IPFS service file removed."
fi

# Ensure there are no startup scripts left
echo "Checking for residual IPFS startup scripts..."
if [ -d "/etc/systemd/system" ]; then
    sudo find /etc/systemd/system -name '*ipfs*' -exec rm -f {} \;
    echo "Removed any residual IPFS system startup scripts."
fi

# Reload systemd to ensure all changes are applied
sudo systemctl daemon-reload

# Optionally, remove IPFS-related logs
echo "Cleaning up IPFS logs..."
sudo find /var/log -name '*ipfs*' -exec rm -f {} \;

echo "IPFS uninstallation complete. The system is now clean."
