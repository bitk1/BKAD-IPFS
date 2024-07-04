#!/bin/bash
#v04
# Check if running as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# Set the path to the new splash image
new_splash_path="/home/bitk1/BKAD-IPFS/splash.png"

# Check if the file exists
if [ ! -f "$new_splash_path" ]; then
    echo "Splash image not found at $new_splash_path!"
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

# Update config.txt
if ! grep -q "disable_splash=0" /boot/firmware/config.txt; then
    echo "disable_splash=0" >> /boot/firmware/config.txt
fi
if ! grep -q "gpu_mem=" /boot/firmware/config.txt; then
    echo "gpu_mem=128" >> /boot/firmware/config.txt
else
    sed -i 's/gpu_mem=.*/gpu_mem=128/' /boot/firmware/config.txt
fi

# Update cmdline.txt
sed -i 's/$/ quiet splash plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0/' /boot/firmware/cmdline.txt

# Create new Plymouth theme file
cat > /usr/share/plymouth/themes/pix/pix.plymouth << EOL
[Plymouth Theme]
Name=Pix
Description=Custom splash theme
ModuleName=two-step

[two-step]
ImageDir=/usr/share/plymouth/themes/pix
HorizontalAlignment=.5
VerticalAlignment=.5
Transition=none
TransitionDuration=0.0
BackgroundStartColor=0x000000
BackgroundEndColor=0x000000
EOL

# Ensure Plymouth is using the pix theme
plymouth-set-default-theme pix

# Update initramfs
update-initramfs -u

echo "Splash screen updated successfully!"
echo "Reboot your Raspberry Pi to see the changes."
