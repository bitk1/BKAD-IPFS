#!/bin/bash

# Define the correct user's home directory
USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)

# Define the path to the Openbox configuration file
CONFIG_FILE="$USER_HOME/.config/openbox/lxde-pi-rc.xml"

# Ensure the Openbox configuration directory exists
mkdir -p "$(dirname "$CONFIG_FILE")"

# Create a basic configuration file if it does not exist
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Creating a new Openbox configuration file."
    echo '<?xml version="1.0" encoding="UTF-8"?>' > "$CONFIG_FILE"
    echo '<openbox_config>' >> "$CONFIG_FILE"
    echo '    <menu id="root-menu" label="Root Menu">' >> "$CONFIG_FILE"
    echo '    </menu>' >> "$CONFIG_FILE"
    echo '</openbox_config>' >> "$CONFIG_FILE"
fi

# Add the Terminal entry only if it doesn't already exist
if grep -q 'label="Terminal"' "$CONFIG_FILE"; then
    echo "Terminal entry already exists in the context menu."
else
    awk '/<\/menu>/{print "        <item label=\"Terminal\">\n            <action name=\"Execute\">\n                <command>lxterminal</command>\n            </action>\n        </item>";}1' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    echo "Terminal entry added to the context menu."
fi

# Reconfigure Openbox to apply changes
export DISPLAY=:0
export XAUTHORITY="$USER_HOME/.Xauthority"
if openbox --reconfigure; then
    echo "Openbox configuration reloaded successfully."
else
    echo "Failed to reload Openbox configuration. Check if Openbox is properly installed and running."
fi
