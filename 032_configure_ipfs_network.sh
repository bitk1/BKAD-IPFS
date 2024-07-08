#!/bin/bash

# Set IPFS configuration for network
sudo -u bitk1 -i bash -c 'ipfs config --json Addresses.Swarm "[\"/ip4/192.168.1.0/tcp/4001\", \"/ip6/::1/tcp/4001\"]"'
sudo -u bitk1 -i bash -c 'ipfs config Addresses.API "/ip4/192.168.1.103/tcp/5001"'
sudo -u bitk1 -i bash -c 'ipfs config Addresses.Gateway "/ip4/192.168.1.103/tcp/8080"'
