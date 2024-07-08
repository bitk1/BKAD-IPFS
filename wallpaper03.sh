#!/bin/bash

# Set the path to the new wallpaper image
new_wallpaper_path="/home/bitk1/BKAD-IPFS/wallpaper.png"

# Check if the file exists and is a PNG
if [ ! -f "$new_wallpaper_path" ] || [[ $(file -b --mime-type "$new_wallpaper_path") != "image/png" ]]; then
    echo "Wallpaper image not found or is not a PNG at $new_wallpaper_path!"
    exit 1
fi

# Copy the new wallpaper to a system-wide accessible location
system_wallpaper_path="/usr/share/rpd-wallpaper/custom_wallpaper.png"
cp "$new_wallpaper_path" "$system_wallpaper_path"

# Update the LXDE configuration file
pcmanfm --set-wallpaper "$system_wallpaper_path" --profile LXDE

echo "Desktop background updated successfully!"
