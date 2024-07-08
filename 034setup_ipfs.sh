#!/bin/bash

# This script sets up IPFS on a Raspberry Pi and ensures SSH access is preserved.
# It is assumed that this script is run with root privileges.

echo "Starting IPFS setup..."

# Install IPFS
echo "Downloading and installing IPFS..."
wget https://dist.ipfs.io/go-ipfs/v0.12.2/go-ipfs_v0.12.2_linux-arm64.tar.gz -O go-ipfs.tar.gz
tar -xvzf go-ipfs.tar.gz
cd go-ipfs
./install.sh
cd ..
rm -rf go-ipfs go-ipfs.tar.gz

# Initialize IPFS as user 'bitk1' if not already initialized
if [ ! -d "/home/bitk1/.ipfs" ]; then
    echo "Initializing IPFS..."
    sudo -u bitk1 -H bash -c 'ipfs init'
fi

# Create Systemd Service for IPFS
echo "Configuring IPFS service..."
cat <<EOF | sudo tee /etc/systemd/system/ipfs.service
[Unit]
Description=IPFS Daemon
After=network.target

[Service]
Type=simple
User=bitk1
ExecStart=/usr/local/bin/ipfs daemon --enable-gc
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start IPFS service
systemctl daemon-reload
systemctl enable ipfs
systemctl start ipfs

# Install UFW if not installed
apt-get update
apt-get install -y ufw

# Configure firewall
echo "Configuring firewall rules..."
ufw allow ssh
ufw allow from 192.168.1.0/24 to any port 4001
ufw allow from 192.168.1.0/24 to any port 5001
ufw allow from 192.168.1.0/24 to any port 8080

# Enable and reload firewall, ensure SSH is not disrupted
echo "y" | ufw enable
ufw reload

echo "IPFS setup complete. Please verify WebUI is accessible via http://192.168.1.103:5001/webui/"
