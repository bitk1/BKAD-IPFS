#!/bin/bash

# Define correct DISPLAY and XAUTHORITY for GUI applications run as sudo
export DISPLAY=:0
export XAUTHORITY=/home/bitk1/.Xauthority

# Ensure the Openbox directory exists and the script can write to it
CONFIG_FILE="/home/bitk1/.config/openbox/lxde-pi-rc.xml"
sudo mkdir -p "$(dirname "$CONFIG_FILE")"
sudo touch "$CONFIG_FILE"
sudo chown $USER: "$CONFIG_FILE"

# Add a menu item to the Openbox configuration
if ! grep -q 'label="Open Terminal"' "$CONFIG_FILE"; then
    sudo awk '/<\/menu>/ {print "      <item label=\"Open Terminal\">\n        <action name=\"Execute\">\n          <command>lxterminal</command>\n        </action>\n      </item>"}1' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && sudo mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    echo "Terminal entry added to the context menu."
else
    echo "Terminal entry already exists."
fi

# Reload Openbox configuration
sudo openbox --reconfigure
