#!/bin/bash
#v05
# Create the desktop shortcut file
echo "[Desktop Entry]" >> ~/Desktop/BKAD-IPFS.desktop
echo "Type=Application" >> ~/Desktop/BKAD-IPFS.desktop
echo "Name=BKAD-IPFS" >> ~/Desktop/BKAD-IPFS.desktop
echo "Comment=BKAD-IPFS Web Interface" >> ~/Desktop/BKAD-IPFS.desktop
echo "Exec=xdg-open http://127.0.0.1:5001/webui" >> ~/Desktop/BKAD-IPFS.desktop
echo "Icon=~/BKAD-IPFS/bk_circle_300.png" >> ~/Desktop/BKAD-IPFS.desktop
echo "Terminal=false" >> ~/Desktop/BKAD-IPFS.desktop

# Remove the wastebasket icon
rm ~/Desktop/Trash.desktop

# Make the file executable
chmod +x ~/Desktop/BKAD-IPFS.desktop
