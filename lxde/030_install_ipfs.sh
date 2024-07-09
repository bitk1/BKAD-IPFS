#!/bin/bash

# Download and extract IPFS
wget https://dist.ipfs.io/go-ipfs/v0.12.2/go-ipfs_v0.12.2_linux-arm64.tar.gz
tar -xvzf go-ipfs_v0.12.2_linux-arm64.tar.gz
cd go-ipfs
sudo ./install.sh

# Cleanup
cd ..
rm -rf go-ipfs go-ipfs_v0.12.2_linux-arm64.tar.gz

# Initialize IPFS under the user 'bitk1'
sudo -u bitk1 -i bash -c 'ipfs init'
