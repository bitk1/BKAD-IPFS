#!/bin/bash

# Set the path to the new wallpaper image
new_wallpaper_path="/home/bitk1/BKAD-IPFS/wallpaper.png"

# Check if the file exists and is a PNG
if [ ! -f "$new_wallpaper_path" ] || [[ $(file -b --mime-type "$new_wallpaper_path") != "image/png" ]]; then
    echo "Wallpaper image not found or is not a PNG at $new_wallpaper_path!"
    exit 1
fi

# Ensure script has permission to write to the wallpaper directory
system_wallpaper_path="/usr/share/rpd-wallpaper/custom_wallpaper.png"
sudo cp "$new_wallpaper_path" "$system_wallpaper_path"

# Pass the DISPLAY variable and update the LXDE configuration
export DISPLAY=:0
export XAUTHORITY=~/.Xauthority
pcmanfm --set-wallpaper "$system_wallpaper_path" --wallpaper-mode=fit --profile LXDE

echo "Desktop background updated successfully!"
