#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Path to the system-wide LXDE panel configuration file
panel_config="/etc/xdg/lxpanel/LXDE-pi/panels/panel"

# Backup the original configuration
cp "$panel_config" "${panel_config}.bak"

# Modify the panel configuration to hide it
sed -i 's/^autohide=.*/autohide=1/' "$panel_config"
sed -i 's/^heightwhenhidden=.*/heightwhenhidden=0/' "$panel_config"

# Ensure the changes are applied to all users
for user_home in /home/*; do
    username=$(basename "$user_home")
    user_panel_config="$user_home/.config/lxpanel/LXDE-pi/panels/panel"
    if [ -f "$user_panel_config" ]; then
        cp "$panel_config" "$user_panel_config"
        chown $username:$username "$user_panel_config"
    fi
done

# Also update the skeleton directory for new users
skeleton_panel_config="/etc/skel/.config/lxpanel/LXDE-pi/panels/panel"
mkdir -p "$(dirname "$skeleton_panel_config")"
cp "$panel_config" "$skeleton_panel_config"

echo "Taskbar (panel) has been set to auto-hide with height 0 when hidden."
echo "This change has been applied system-wide and to all existing user configurations."
echo "Changes will take effect after a reboot or when users log out and log back in."

# Optionally, try to restart lxpanel for all logged-in users
ps aux | grep lxpanel | grep -v grep | awk '{print $2}' | xargs -r kill

echo "Please reboot your Raspberry Pi for the changes to take full effect."
