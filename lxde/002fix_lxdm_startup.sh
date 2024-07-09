#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "Configuring LXDM to start properly..."

# Configure LXDM with a delay to ensure all dependencies are ready
echo "Creating LXDM service override to add a delay..."
mkdir -p /etc/systemd/system/lxdm.service.d
cat <<EOF > /etc/systemd/system/lxdm.service.d/override.conf
[Service]
ExecStartPre=/bin/sleep 10
EOF

# Reload systemd to apply changes
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Enable LXDM to start at boot
echo "Ensuring LXDM is enabled to start at boot..."
systemctl enable lxdm

# Restart LXDM service
echo "Restarting LXDM service..."
systemctl restart lxdm

echo "Setup completed. LXDM is configured to start with a delay."
