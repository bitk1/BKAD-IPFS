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
mkdir -p /etc/skel/.config/lxpanel/LXDE-pi/panels
cp "$panel_config" /etc/skel/.config/lxpanel/LXDE-pi/panels/

echo "Taskbar (panel) has been set to auto-hide with height 0 when hidden."
echo "This change will apply to all new users and existing users after they log out and log back in."
echo "To apply changes immediately for the current session, run: lxpanelctl restart"

# Attempt to restart the panel for the current user
su - pi -c "DISPLAY=:0 lxpanelctl restart" || true

echo "You may need to log out and log back in, or restart the Pi for changes to take full effect."
