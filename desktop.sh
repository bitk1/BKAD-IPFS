#!/bin/bash

# Set HOME variable explicitly
HOME=/home/bitk1

# Create lxpanel directory if it does not exist
if [ ! -d $HOME/.config/lxpanel ]; then
    mkdir -p $HOME/.config/lxpanel
fi

# Create panels file if it does not exist
if [ ! -f $HOME/.config/lxpanel/LXDE/panels ]; then
    touch $HOME/.config/lxpanel/LXDE/panels
fi

# Hide taskbar
echo "taskbar.hide=1" >> $HOME/.config/lxpanel/LXDE/panels
