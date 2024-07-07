#!/bin/bash

# Script to add "Open Terminal Here" to the desktop right-click menu on Raspberry Pi OS LXDE environment

# Ensure running as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Step 1: Create a global desktop entry for lxterminal
cat << EOF | sudo tee /usr/share/applications/lxterminal-here.desktop > /dev/null
[Desktop Entry]
Type=Application
Name=Open Terminal Here
Comment=Open a terminal in the current folder
Icon=utilities-terminal
Exec=lxterminal
Terminal=false
EOF

# Step 2: Ensure global configuration for PCManFM is adapted
# This targets the default settings for all users
GLOBAL_CONFIG="/etc/xdg/libfm/libfm.conf"
if [ ! -f "$GLOBAL_CONFIG" ]; then
    sudo mkdir -p "$(dirname "$GLOBAL_CONFIG")"
    echo "[desktop]" | sudo tee "$GLOBAL_CONFIG" > /dev/null
fi

if grep -q "\[desktop\]" "$GLOBAL_CONFIG"; then
    sudo sed -i '/^\[desktop\]$/,/^\[/ s/^quick_exec=.*$/quick_exec=1/' "$GLOBAL_CONFIG"
else
    echo "quick_exec=1" | sudo tee -a "$GLOBAL_CONFIG" > /dev/null
fi

# Step 3: Restart PCManFM to apply changes globally
pkill pcmanfm
sudo -u pi pcmanfm --desktop &  # Assuming the default user is 'pi', adjust as necessary for your setup

echo "The 'Open Terminal Here' option has been added to the desktop context menu."
