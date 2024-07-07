#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Set the path to the new wallpaper image
new_wallpaper_path="/home/bitk1/BKAD-IPFS/wallpaper.png"

# Check if the file exists
if [ ! -f "$new_wallpaper_path" ]; then
    echo "Wallpaper image not found at $new_wallpaper_path!"
    exit 1
fi

# Check if the file is a PNG
if [[ $(file -b --mime-type "$new_wallpaper_path") != "image/png" ]]; then
    echo "The file is not a PNG image!"
    exit 1
fi

# Copy the new wallpaper to a system-wide accessible location
system_wallpaper_path="/usr/share/rpd-wallpaper/custom_wallpaper.png"
cp "$new_wallpaper_path" "$system_wallpaper_path"

# Set correct permissions
chmod 644 "$system_wallpaper_path"

# Update the LXDE configuration file
config_file="/etc/xdg/pcmanfm/LXDE-pi/desktop-items-0.conf"

# Backup the original configuration
cp "$config_file" "${config_file}.bak"

# Update the wallpaper path in the configuration
sed -i "s|wallpaper=.*|wallpaper=$system_wallpaper_path|" "$config_file"

# Ensure wallpaper mode is set to crop (you can change this if needed)
sed -i "s|wallpaper_mode=.*|wallpaper_mode=crop|" "$config_file"

# Ensure wallpaper is set to common for all users
sed -i "s|wallpaper_common=.*|wallpaper_common=1|" "$config_file"

echo "Desktop background updated successfully!"
echo "You may need to log out and log back in, or restart the Pi to see the changes."
