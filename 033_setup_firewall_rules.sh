#!/bin/bash

# Enable UFW and set default rules
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow IPFS traffic on local subnet
sudo ufw allow from 192.168.1.0/24 to any port 4001
sudo ufw allow from 192.168.1.0/24 to any port 5001
sudo ufw allow from 192.168.1.0/24 to any port 8080

# Enable firewall
sudo ufw enable
