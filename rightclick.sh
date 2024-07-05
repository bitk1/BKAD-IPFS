#!/bin/bash

# Define the path to the Openbox configuration file
CONFIG_FILE="$HOME/.config/openbox/lxde-pi-rc.xml"

# Backup the original configuration file
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"

# Check if the Terminal entry already exists to prevent duplicates
if grep -q 'label="Terminal"' "$CONFIG_FILE"; then
    echo "Terminal entry already exists in the context menu."
else
    # Use awk to insert the Terminal menu entry just before the </menu> tag of the root-menu
    awk '/<\/menu>/{print "      <item label=\"Terminal\">\n        <action name=\"Execute\">\n          <command>lxterminal</command>\n        </action>\n      </item>";}1' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"

    echo "Terminal entry added to the context menu."

    # Reconfigure Openbox to apply changes
    openbox --reconfigure
    echo "Openbox configuration reloaded."
fi
