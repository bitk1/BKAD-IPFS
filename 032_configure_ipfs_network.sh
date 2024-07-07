#!/bin/bash

# Configure IPFS to listen on local subnet
ipfs config Addresses.Swarm ["/ip4/192.168.1.0/tcp/4001", "/ip6/::1/tcp/4001"]
ipfs config Addresses.API "/ip4/192.168.1.103/tcp/5001"
ipfs config Addresses.Gateway "/ip4/192.168.1.103/tcp/8080"
