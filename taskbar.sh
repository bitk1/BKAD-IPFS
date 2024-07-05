#!/bin/bash

# Check if the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi

# Backup original files
cp /etc/xdg/lxpanel/LXDE-pi/panels/panel /etc/xdg/lxpanel/LXDE-pi/panels/panel.bak
cp /etc/xdg/lxsession/LXDE-pi/autostart /etc/xdg/lxsession/LXDE-pi/autostart.bak

# Modify the panel configuration to hide the taskbar
sed -i 's/autohide=0/autohide=1/' /etc/xdg/lxpanel/LXDE-pi/panels/panel
sed -i 's/heightwhenhidden=2/heightwhenhidden=1/' /etc/xdg/lxpanel/LXDE-pi/panels/panel

# Remove the taskbar plugin
sed -i '/type=taskbar/,/}/d' /etc/xdg/lxpanel/LXDE-pi/panels/panel

# Ensure lxpanel starts in the system-wide autostart
sed -i 's/^@#lxpanel/@lxpanel/' /etc/xdg/lxsession/LXDE-pi/autostart

# Update user-specific autostart for all users in /home
for user_home in /home/*; do
  if [ -d "$user_home" ]; then
    username=$(basename "$user_home")
    autostart_dir="$user_home/.config/lxsession/LXDE-pi"
    autostart_file="$autostart_dir/autostart"
    
    # Create directory if it doesn't exist
    sudo -u "$username" mkdir -p "$autostart_dir"
    
    # If autostart file doesn't exist, create it with lxpanel entry
    if [ ! -f "$autostart_file" ]; then
      echo "@lxpanel --profile LXDE-pi" | sudo -u "$username" tee "$autostart_file" > /dev/null
    else
      # If file exists, add lxpanel entry if not present
      if ! grep -q "@lxpanel --profile LXDE-pi" "$autostart_file"; then
        sed -i '1i@lxpanel --profile LXDE-pi' "$autostart_file"
      fi
    fi
    
    echo "Updated autostart for user: $username"
  fi
done

echo "Taskbar has been configured to hide for all users."
echo "The system will now reboot for changes to take effect."

# Reboot the system
reboot
