#!/bin/bash

# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Prompt for the path to the new splash image
read -p "Enter the path to your new splash image: " new_splash_path

# Check if the file exists
if [ ! -f "$new_splash_path" ]; then
    echo "File not found!"
    exit 1
fi

# Check if the file is a PNG
if [[ $(file -b --mime-type "$new_splash_path") != "image/png" ]]; then
    echo "The file is not a PNG image!"
    exit 1
fi

# Backup the original splash image
cp /usr/share/plymouth/themes/pix/splash.png /usr/share/plymouth/themes/pix/splash.png.bak

# Copy the new splash image
cp "$new_splash_path" /usr/share/plymouth/themes/pix/splash.png

echo "Splash screen updated successfully!"
echo "Reboot your Raspberry Pi to see the changes."
