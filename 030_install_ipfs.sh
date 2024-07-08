#!/bin/bash

# Download and install IPFS
wget https://dist.ipfs.io/go-ipfs/v0.12.2/go-ipfs_v0.12.2_linux-arm64.tar.gz
tar -xvzf go-ipfs_v0.12.2_linux-arm64.tar.gz
cd go-ipfs
sudo ./install.sh

# Initialize IPFS
ipfs init

# Clean up
cd ..
rm -rf go-ipfs go-ipfs_v0.12.2_linux-arm64.tar.gz
