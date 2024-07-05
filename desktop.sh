#!/bin/bash

# Set HOME variable explicitly
HOME=/home/bitk1

# Create lxsession and LXDE directories if they do not exist
if [ ! -d $HOME/.config/lxsession ]; then
    mkdir -p $HOME/.config/lxsession
fi
if [ ! -d $HOME/.config/lxsession/LXDE ]; then
    mkdir -p $HOME/.config/lxsession/LXDE
fi

# Create desktop.conf file if it does not exist
if [ ! -f $HOME/.config/lxsession/LXDE/desktop.conf ]; then
    touch $HOME/.config/lxsession/LXDE/desktop.conf
fi

# Set desktop to dark mode
echo "[GTK]" >> $HOME/.config/lxsession/LXDE/desktop.conf
echo "theme=Dark" >> $HOME/.config/lxsession/LXDE/desktop.conf

# Hide Wastebasket icon
echo "show_trash=0" >> $HOME/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
