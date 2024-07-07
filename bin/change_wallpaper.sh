#!/bin/bash
#v05
# Create the script file
echo "#!/bin/bash" >> /home/bitk1/change_wallpaper.sh
echo "wallpaper_image=\"/home/bitk1/BKAD-IPFS/wallpaper.png\"" >> /home/bitk1/change_wallpaper.sh
echo "pcmanfm --set-wallpaper \$wallpaper_image" >> /home/bitk1/change_wallpaper.sh

# Make the script executable
chmod +x /home/bitk1/change_wallpaper.sh

# Add the script to crontab to run on startup
crontab -l > tempcron
echo "@reboot /home/bitk1/change_wallpaper.sh" >> tempcron
crontab tempcron
rm tempcron
