#!/bin/bash

# Ensure IPFS is initialized
if [ ! -d "/home/$SUDO_USER/.ipfs" ]; then
    echo "No IPFS repo found in /home/$SUDO_USER/.ipfs. Please run 'ipfs init'."
    exit 1
fi

# Configure IPFS to listen on local subnet
ipfs config --json Addresses.Swarm '["/ip4/192.168.1.0/tcp/4001", "/ip6/::1/tcp/4001"]'
ipfs config Addresses.API "/ip4/192.168.1.103/tcp/5001"
ipfs config Addresses.Gateway "/ip4/192.168.1.103/tcp/8080"
