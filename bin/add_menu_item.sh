#!/bin/bash

# Configuration file path
CONFIG_FILE="$HOME/.config/openbox/lxde-pi-rc.xml"

# Backup the original configuration
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Add a new menu item
awk '/<\/menu>/ && !x {print "    <item label=\"Open Terminal\">\n      <action name=\"Execute\">\n        <command>lxterminal</command>\n      </action>\n    </item>"; x=1} 1' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

# Reload Openbox configuration
openbox --reconfigure

echo "New menu item added and Openbox reconfigured."
