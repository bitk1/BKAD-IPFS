#!/bin/bash

# Set HOME variable explicitly
HOME=/home/bitk1

# Create lxpanel directory if it does not exist
if [ ! -d $HOME/.config/lxpanel ]; then
    mkdir -p $HOME/.config/lxpanel
fi

# Create LXDE directory if it does not exist
if [ ! -d $HOME/.config/lxpanel/LXDE ]; then
    mkdir -p $HOME/.config/lxpanel/LXDE
fi

# Create panels file if it does not exist
if [ ! -f $HOME/.config/lxpanel/LXDE/panels ]; then
    touch $HOME/.config/lxpanel/LXDE/panels
fi

# Change taskbar color to black
echo "bg.color=#000000" >> $HOME/.config/lxpanel/LXDE/panels
