#!/bin/bash

# Install UFW if not present
apt-get install -y ufw

# Setup default rules
ufw default deny incoming
ufw default allow outgoing

# Allow local IPFS traffic
ufw allow from 192.168.1.0/24 to any port 4001 comment 'IPFS Swarm'
ufw allow from 192.168.1.0/24 to any port 5001 comment 'IPFS API'
ufw allow from 192.168.1.0/24 to any port 8080 comment 'IPFS Gateway'

# Enable UFW without confirmation
echo "y" | ufw enable
