#!/bin/bash
#v01
# Set desktop to dark mode
echo "desktop_bg=#000000" >> ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
echo "desktop_fg=#ffffff" >> ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
echo "desktop_shadow=#000000" >> ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf

# Hide Wastebasket icon
echo "show_trash=0" >> ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
