#!/bin/bash

set -e

# Stop IPFS service if it's running
echo "Stopping IPFS service if it's running..."
sudo systemctl stop ipfs || true

# Update and install dependencies
echo "Updating system and installing dependencies..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y wget tar ufw jq curl lxde

# Install IPFS
echo "Installing IPFS..."
wget https://dist.ipfs.io/go-ipfs/v0.11.0/go-ipfs_v0.11.0_linux-arm64.tar.gz
tar -xvzf go-ipfs_v0.11.0_linux-arm64.tar.gz
cd go-ipfs
sudo bash install.sh
cd ..

# Initialize IPFS repository
echo "Initializing IPFS repository..."
sudo -u bitk1 ipfs init

# Configure IPFS to run as a service
echo "Configuring IPFS as a service..."
sudo tee /etc/systemd/system/ipfs.service > /dev/null <<EOL
[Unit]
Description=IPFS daemon
After=network.target

[Service]
User=bitk1
ExecStart=/usr/local/bin/ipfs daemon --enable-gc
Restart=always
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable ipfs
sudo systemctl start ipfs

# Configure IPFS to use local subnet
echo "Configuring IPFS to use local subnet..."
sudo -u bitk1 ipfs config Addresses.Swarm '["/ip4/0.0.0.0/tcp/4001", "/ip4/0.0.0.0/udp/4001/quic", "/ip4/192.168.0.0/tcp/4001", "/ip4/192.168.0.0/udp/4001/quic"]'
sudo -u bitk1 ipfs config Addresses.API '/ip4/127.0.0.1/tcp/5001'
sudo -u bitk1 ipfs config Addresses.Gateway '/ip4/0.0.0.0/tcp/8080'

# Install IPFS web UI
echo "Installing IPFS web UI..."
sudo -u bitk1 ipfs get /ipfs/QmZdJk7c2MzyJd4LTVZc8VzD9ZLyZf4dJtzFCZ8u5nZjns
sudo mv QmZdJk7c2MzyJd4LTVZc8VzD9ZLyZf4dJtzFCZ8u5nZjns /home/bitk1/ipfs-webui
sudo ln -s /home/bitk1/ipfs-webui /var/www/html/ipfs-webui

# Create desktop shortcut
echo "Creating desktop shortcut..."
sudo tee /home/bitk1/Desktop/ipfs-webui.desktop > /dev/null <<EOL
[Desktop Entry]
Name=IPFS Web UI
Comment=Open IPFS Web UI
Exec=xdg-open http://127.0.0.1:5001/webui
Icon=/home/bitk1/bk_circle_300.png
Terminal=false
Type=Application
EOL
sudo chmod +x /home/bitk1/Desktop/ipfs-webui.desktop

# Set desktop wallpaper
echo "Setting desktop wallpaper..."
WALLPAPER_PATH="/home/bitk1/bk_reverse.png"
sudo mkdir -p /home/bitk1/.config/pcmanfm/LXDE/
sudo tee /home/bitk1/.config/pcmanfm/LXDE/desktop-items-0.conf > /dev/null <<EOL
[*]
wallpaper_mode=crop
wallpaper=$WALLPAPER_PATH
EOL

# Restart LXDE desktop session
sudo systemctl restart lightdm

# Install and configure UFW
echo "Installing and configuring UFW..."
sudo apt-get install ufw -y
echo "y" | sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH access from the local subnet
sudo ufw allow from 192.168.0.0/16 to any port 22 proto tcp

# Allow IPFS ports from the local subnet
sudo ufw allow from 192.168.0.0/16 to any port 4001 proto tcp
sudo ufw allow from 192.168.0.0/16 to any port 4001 proto udp
sudo ufw allow from 192.168.0.0/16 to any port 5001 proto tcp
sudo ufw allow from 192.168.0.0/16 to any port 8080 proto tcp

sudo ufw reload

# Install IPFS Cluster
echo "Installing IPFS Cluster..."
wget https://dist.ipfs.io/ipfs-cluster-service/v0.14.0/ipfs-cluster-service_v0.14.0_linux-arm64.tar.gz
tar -xvzf ipfs-cluster-service_v0.14.0_linux-arm64.tar.gz
sudo mv ipfs-cluster-service/ipfs-cluster-service /usr/local/bin/
wget https://dist.ipfs.io/ipfs-cluster-ctl/v0.14.0/ipfs-cluster-ctl_v0.14.0_linux-arm64.tar.gz
tar -xvzf ipfs-cluster-ctl_v0.14.0_linux-arm64.tar.gz
sudo mv ipfs-cluster-ctl/ipfs-cluster-ctl /usr/local/bin/

# Initialize IPFS Cluster
echo "Initializing IPFS Cluster..."
sudo -u bitk1 ipfs-cluster-service init
sudo -u bitk1 ipfs-cluster-service daemon &

# Configure IPFS Cluster to run as a service
echo "Configuring IPFS Cluster as a service..."
sudo tee /etc/systemd/system/ipfs-cluster.service > /dev/null <<EOL
[Unit]
Description=IPFS Cluster Service
After=network.target
Wants=ipfs.service

[Service]
User=bitk1
ExecStart=/usr/local/bin/ipfs-cluster-service daemon
Restart=always
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable ipfs-cluster
sudo systemctl start ipfs-cluster

# Create script for auto pinning files from external hard drive
echo "Creating script for auto pinning files from external hard drive..."
sudo tee /usr/local/bin/auto_pin_external.sh > /dev/null <<EOL
#!/bin/bash
MOUNT_PATH="/mnt/external"
IPFS_PATH="\$MOUNT_PATH/ipfs"
if mountpoint -q \$MOUNT_PATH; then
  for file in \$(find \$IPFS_PATH -type f); do
    ipfs add -r \$file | grep "added" | awk '{print \$2}' | xargs -I {} ipfs-cluster-ctl pin add {}
  done
fi
EOL
sudo chmod +x /usr/local/bin/auto_pin_external.sh

# Create systemd service for auto pinning from external hard drive
echo "Creating systemd service for auto pinning from external hard drive..."
sudo tee /etc/systemd/system/auto_pin_external.service > /dev/null <<EOL
[Unit]
Description=Auto Pin IPFS Files from External Hard Drive
After=network.target

[Service]
User=bitk1
ExecStart=/usr/local/bin/auto_pin_external.sh

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable auto_pin_external

# Create script for auto pinning files from other nodes on the same subnet
echo "Creating script for auto pinning files from other nodes on the same subnet..."
sudo tee /usr/local/bin/auto_pin_subnet.sh > /dev/null <<EOL
#!/bin/bash
SUBNET="192.168"
for ip1 in \$(seq 0 255); do
  for ip2 in \$(seq 1 254); do
    NODE="\$SUBNET.\$ip1.\$ip2"
    if ipfs swarm connect /ip4/\$NODE/tcp/4001; then
      ipfs-cluster-ctl sync --force
    fi
  done
done
EOL
sudo chmod +x /usr/local/bin/auto_pin_subnet.sh

# Create systemd timer for auto pinning from other nodes on the same subnet
echo "Creating systemd timer for auto pinning from other nodes on the same subnet..."
sudo tee /etc/systemd/system/auto_pin_subnet.timer > /dev/null <<EOL
[Unit]
Description=Run auto pinning from other nodes on the same subnet periodically

[Timer]
OnBootSec=15min
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
EOL

sudo tee /etc/systemd/system/auto_pin_subnet.service > /dev/null <<EOL
[Unit]
Description=Auto Pin IPFS Files from Other Nodes on the Same Subnet
After=network.target

[Service]
User=bitk1
ExecStart=/usr/local/bin/auto_pin_subnet.sh

[Install]
WantedBy=multi-user.target
EOL

sudo systemctl enable auto_pin_subnet.timer
sudo systemctl start auto_pin_subnet.timer

echo "Installation complete.
