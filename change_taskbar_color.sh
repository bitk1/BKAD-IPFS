#!/bin/bash

# Change the taskbar color to black
sed -i 's/tintcolor=#000000/tintcolor=#000000/g' /etc/xdg/lxpanel/LXDE-pi/panels/panel

# Ensure lxpanel is installed
sudo apt update
sudo apt install lxpanel

# Ensure lxpanel is enabled
sudo systemctl enable lxpanel

# Start lxpanel
sudo systemctl start lxpanel

# Check if there are any errors in the lxpanel logs
sudo journalctl -u lxpanel

# Check if there are any other configuration files overriding your changes
sudo grep -r "tintcolor" /etc/xdg/lxpanel/
grep -r "tintcolor" ~/.config/lxpanel/

# Check if there are any other services or processes overriding your changes
ps -ef | grep lxpanel
sudo systemctl list-units | grep lxpanel
