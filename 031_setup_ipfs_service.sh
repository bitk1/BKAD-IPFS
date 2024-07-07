#!/bin/bash

# Create a systemd service file for IPFS
echo "[Unit]
Description=IPFS Daemon
After=network.target

[Service]
Type=simple
User=bitk1
ExecStart=/usr/local/bin/ipfs daemon --enable-gc
Restart=on-failure

[Install]
WantedBy=multi-user.target" | sudo tee /etc/systemd/system/ipfs.service

# Enable and start the service
sudo systemctl enable ipfs
sudo systemctl start ipfs
