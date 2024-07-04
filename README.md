# BKAD-IPFS

## Introduction

BKAD-IPFS (BitKnowledge Archive Device IPFS edition) is a project to set up a BKAD, which is a small device for local digital archiving using IPFS. It allows users to upload and read files using the native IPFS web interface and synchronise with local devices. The IPFS web interface can be accessed on the device by clicking on the desktop shortcut (http://127.0.0.1:5001/webui) or by accessing the local IP address from a browser on a local private 192.168.0.0/16 subnet, e.g. http://192.168.1.103:5001/webui. For long-term access purposes, no native local encryption is used. However, to maintain local security:

	1.	The IPFS daemon is configured to bind to the local subnet addresses and localhost.
	2.	The Swarm addresses are restricted to the local subnet.
	3.	The API and Gateway addresses are set to bind to localhost and the device’s IP within the subnet.
	4.	The locally installed firewall (UFW) restricts incoming connections to IPFS ports 4001, 5001, and 8080 from the 192.168.0.0/16 subnet only.

## Usage 

Access the IPFS Web UI at http://127.0.0.1:5001/webui in a local web browser or http://192.168.1.103:5001/webui from another machine on the same subnet (replace with actual ip address). 

## License
This project is licensed under the MIT License.

### Next clone from GitHub and install:


```bash
git clone https://github.com/bitk1/BKAD-IPFS.git 

cd BKAD-IPFS

sudo bash setup_bkad.sh

sudo reboot
