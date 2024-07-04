#!/bin/bash
#v05
# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
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

# Copy the new splash image
cp "$new_splash_path" /usr/share/plymouth/themes/pix/splash.png

# Set correct permissions
chmod 644 /usr/share/plymouth/themes/pix/splash.png
chmod 755 /usr/share/plymouth/themes/pix

# Update config.txt
if ! grep -q "disable_splash=0" /boot/firmware/config.txt; then
    echo "disable_splash=0" >> /boot/firmware/config.txt
fi
if ! grep -q "gpu_mem=" /boot/firmware/config.txt; then
    echo "gpu_mem=128" >> /boot/firmware/config.txt
else
    sed -i 's/gpu_mem=.*/gpu_mem=128/' /boot/firmware/config.txt
fi

# Clean up and update cmdline.txt
sed -i 's/quiet splash plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0//g' /boot/firmware/cmdline.txt
sed -i 's/$/ quiet splash plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0/' /boot/firmware/cmdline.txt

# Create new Plymouth theme file
cat > /usr/share/plymouth/themes/pix/pix.plymouth << EOL
[Plymouth Theme]
Name=Pix
Description=Custom splash theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/pix
ScriptFile=/usr/share/plymouth/themes/pix/pix.script
EOL

# Create new Plymouth script file with aspect ratio preservation
cat > /usr/share/plymouth/themes/pix/pix.script << EOL
splash_image = Image("splash.png");
screen_width = Window.GetWidth();
screen_height = Window.GetHeight();

image_width = splash_image.GetWidth();
image_height = splash_image.GetHeight();

scale_x = screen_width / image_width;
scale_y = screen_height / image_height;
scale = Math.Min(scale_x, scale_y);

scaled_width = image_width * scale;
scaled_height = image_height * scale;

x = (screen_width - scaled_width) / 2;
y = (screen_height - scaled_height) / 2;

resized_image = splash_image.Scale(scaled_width, scaled_height);
sprite = Sprite(resized_image);
sprite.SetPosition(x, y, 0);
EOL

# Set Plymouth theme and update initramfs
plymouth-set-default-theme -R pix

# Update initramfs
update-initramfs -u

echo "Splash screen updated successfully!"
echo "Reboot your Raspberry Pi to see the changes."
