#!/bin/bash
#v08
# Set HOME variable explicitly
HOME=/home/bitk1

# Set desktop to dark mode
echo "[GTK]" >> $HOME/.config/lxsession/LXDE/desktop.conf
echo "theme=Dark" >> $HOME/.config/lxsession/LXDE/desktop.conf

# Hide Wastebasket icon
echo "show_trash=0" >> $HOME/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
