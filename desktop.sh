#!/bin/bash
#v03
# Set desktop to dark mode
echo "[GTK]" >> ~/.config/lxsession/LXDE/desktop.conf
echo "theme=Dark" >> ~/.config/lxsession/LXDE/desktop.conf

# Hide Wastebasket icon
echo "show_trash=0" >> ~/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
