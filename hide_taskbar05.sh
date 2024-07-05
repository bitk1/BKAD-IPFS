#!/bin/bash

# Auto hide the panel for all users
sed -i 's/edge=top/edge=top\n  autohide=1/' /etc/xdg/lxpanel/LXDE-pi/panels/panel

# Disable the taskbar for all users
sed -i 's@lxpanel --profile LXDE@#lxpanel --profile LXDE@g' /etc/xdg/lxsession/LXDE-pi/autostart

# Check if the directory exists before copying files
if [ -d /etc/xdg/lxpanel/profile/LXDE ]; then
    cp -rp /etc/xdg/lxpanel/profile/LXDE/* /etc/xdg/lxpanel/profile/LXDE/
else
    echo "Directory /etc/xdg/lxpanel/profile/LXDE does not exist."
fi
