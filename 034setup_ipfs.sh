#!/bin/bash

# Ensure the script is run with root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo "Starting IPFS setup..."

# Install IPFS
echo "Downloading and installing IPFS..."
wget https://dist.ipfs.io/go-ipfs/v0.12.2/go-ipfs_v0.12.2_linux-arm64.tar.gz -O go-ipfs.tar.gz
tar -xvzf go-ipfs.tar.gz
cd go-ipfs
./install.sh
cd ..
rm -rf go-ipfs go-ipfs.tar.gz

# Check if IPFS is initialized, and if not, initialize it as user 'bitk1'
if [ ! -d "/home/bitk1/.ipfs" ]; then
    echo "Initializing IPFS..."
    sudo -u bitk1 -H bash -c 'ipfs init'
fi

# Creating IPFS systemd service file
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

# Reload systemd to apply changes, enable and start IPFS service
systemctl daemon-reload
systemctl enable ipfs
systemctl start ipfs

# Install UFW if it is not already installed
if ! command -v ufw &> /dev/null
then
    echo "UFW not found, installing..."
    apt-get install -y ufw
fi

# Configuring firewall rules to allow SSH and IPFS
echo "Configuring firewall rules..."
ufw allow ssh
ufw allow from 192.168.1.0/24 to any port 4001
ufw allow from 192.168.1.0/24 to any port 5001
ufw allow from 192.168.1.0/24 to any port 8080

# Enabling and reloading firewall, ensuring SSH is not disrupted
echo "y" | ufw enable
ufw reload

echo "IPFS setup complete. Please verify the WebUI is accessible via http://192.168.1.103:5001/webui/"
