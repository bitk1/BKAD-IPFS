#!/bin/bash

# Change the taskbar color to black for all users
sed -i 's/tintcolor=#000000/tintcolor=#000000/g' /etc/xdg/lxpanel/LXDE-pi/panels/panel

# Update user-specific configuration files
for user in /home/*; do
    if [ -d "$user" ]; then
        user_name=$(basename "$user")
        user_config_file="/home/$user_name/.config/lxpanel/LXDE-pi/panels/panel"
        if [ -f "$user_config_file" ]; then
            sed -i 's/tintcolor=#000000/tintcolor=#000000/g' "$user_config_file"
        fi
    fi
done
