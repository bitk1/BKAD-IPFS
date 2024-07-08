#!/bin/bash

# Create and configure the systemd service file for IPFS
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
sudo systemctl daemon-reload
sudo systemctl enable ipfs
sudo systemctl start ipfs
sudo systemctl status ipfs
