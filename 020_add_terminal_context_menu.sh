#!/bin/bash

# Script to add "Open Terminal Here" to the desktop right-click menu on Raspberry Pi OS LXDE environment

# Step 1: Create a desktop entry for lxterminal
cat << EOF | sudo tee /usr/share/applications/lxterminal-here.desktop
[Desktop Entry]
Type=Application
Name=Open Terminal Here
Comment=Open a terminal in the current folder
Icon=utilities-terminal
Exec=lxterminal
Terminal=false
EOF

# Step 2: Modify the PCManFM configuration
# Check if the config directory exists, if not create it
if [ ! -d ~/.config/libfm ]; then
    mkdir -p ~/.config/libfm
fi

# Append or modify quick_exec in libfm.conf
if grep -q "\[desktop\]" ~/.config/libfm/libfm.conf; then
    # If desktop section exists, ensure quick_exec is set
    sed -i '/^\[desktop\]$/,/^\[/ s/^quick_exec=.*$/quick_exec=1/' ~/.config/libfm/libfm.conf
else
    # If no desktop section, append it
    echo -e "[desktop]\nquick_exec=1" >> ~/.config/libfm/libfm.conf
fi

# Step 3: Restart PCManFM to apply changes
pkill pcmanfm
pcmanfm --desktop &

echo "The 'Open Terminal Here' option has been added to the desktop context menu."
