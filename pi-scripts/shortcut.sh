#!/bin/bash
#v06
# Create the desktop shortcut file
echo "[Desktop Entry]" >> /home/bitk1/Desktop/BKAD-IPFS.desktop
echo "Type=Application" >> /home/bitk1/Desktop/BKAD-IPFS.desktop
echo "Name=BKAD-IPFS" >> /home/bitk1/Desktop/BKAD-IPFS.desktop
echo "Comment=BKAD-IPFS Web Interface" >> /home/bitk1/Desktop/BKAD-IPFS.desktop
echo "Exec=xdg-open http://127.0.0.1:5001/webui" >> /home/bitk1/Desktop/BKAD-IPFS.desktop
echo "Icon=/home/bitk1/BKAD-IPFS/bk_circle_300.png" >> /home/bitk1/Desktop/BKAD-IPFS.desktop
echo "Terminal=false" >> /home/bitk1/Desktop/BKAD-IPFS.desktop

# Remove the wastebasket icon if it exists
if [ -f /home/bitk1/Desktop/Trash.desktop ]; then
    sudo rm /home/bitk1/Desktop/Trash.desktop
fi

# Make the file executable
sudo chmod +x /home/bitk1/Desktop/BKAD-IPFS.desktop
