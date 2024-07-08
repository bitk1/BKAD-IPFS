#!/bin/bash

# Install UFW if not installed
if ! command -v ufw &> /dev/null; then
    sudo apt-get update
    sudo apt-get install ufw
fi

# Configure firewall rules
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow from 192.168.1.0/24 to any port 4001
sudo ufw allow from 192.168.1.0/24 to any port 5001
sudo ufw allow from 192.168.1.0/24 to any port 8080

# Enable the firewall
sudo ufw enable
