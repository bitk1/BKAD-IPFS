#!/bin/bash

# Set the path to the new splash image
new_splash_path="/home/bitk1/BKAD-IPFS/splash.png"

# Check if the file exists and is a PNG
if [ ! -f "$new_splash_path" ] || [[ $(file -b --mime-type "$new_splash_path") != "image/png" ]]; then
    echo "Splash image not found or is not a PNG at $new_splash_path!"
    exit 1
fi

# Copy the new splash image
cp "$new_splash_path" /usr/share/plymouth/themes/pix/splash.png

# Update initramfs to apply changes
update-initramfs -u

echo "Splash screen updated successfully!"
