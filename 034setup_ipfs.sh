#!/bin/bash

# This script assumes it's run with root privileges or via sudo

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
cat <<EOF | tee /etc/systemd/system/ipfs.service
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

# Reload systemd and start IPFS service
systemctl daemon-reload
systemctl enable ipfs
systemctl restart ipfs

# Configure firewall
echo "Configuring firewall rules..."
apt-get install -y ufw
ufw allow from 192.168.1.0/24 to any port 4001
ufw allow from 192.168.1.0/24 to any port 5001
ufw allow from 192.168.1.0/24 to any port 8080
echo "y" | ufw enable

# Wait for IPFS to start and check WebUI
echo "Checking IPFS WebUI accessibility..."
sleep 10
curl -I http://localhost:5001/webui

echo "IPFS setup complete. Please verify WebUI is accessible via http://192.168.1.103:5001/webui/"
