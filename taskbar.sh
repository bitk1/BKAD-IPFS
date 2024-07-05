#!/bin/bash

# Stop the currently running panel
killall wf-panel-pi

# Remove panel from autostart
sed -i '/wf-panel-pi/d' /etc/xdg/autostart/*.desktop
sed -i '/wf-panel-pi/d' ~/.config/autostart/*.desktop

# Remove panel from Wayfire config
sed -i '/panel/d' /etc/wayfire.ini
sed -i '/panel/d' ~/.config/wayfire.ini

# Disable panel respawn
sed -i 's/wfrespawn wf-panel-pi//' /etc/xdg/wayfire/autostart

# Remove panel from user's Wayfire autostart if it exists
if [ -f ~/.config/wayfire/autostart ]; then
    sed -i 's/wfrespawn wf-panel-pi//' ~/.config/wayfire/autostart
fi

echo "Panel removal complete. Please reboot or restart your Wayfire session for changes to take effect."
