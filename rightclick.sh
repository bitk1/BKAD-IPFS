#!/bin/bash

# Determine the correct user's home directory
if [ -n "$SUDO_USER" ]; then
    # When running with sudo, find the home directory of the user who invoked sudo
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    # When not running with sudo, use the current user's home directory
    USER_HOME=$HOME
fi

# Define the path to the Openbox configuration file
CONFIG_FILE="$USER_HOME/.config/openbox/lxde-pi-rc.xml"

# Ensure the Openbox directory exists
mkdir -p "$(dirname "$CONFIG_FILE")"

# Backup the original configuration file
if [ -f "$CONFIG_FILE" ]; then
    cp "$CONFIG_FILE" "${CONFIG_FILE}.bak"
fi

# Add the Terminal entry only if it doesn't already exist
if grep -q 'label="Terminal"' "$CONFIG_FILE"; then
    echo "Terminal entry already exists in the context menu."
else
    # Use awk to insert the Terminal menu entry just before the </menu> tag of the root-menu
    awk '/<\/menu>/{print "      <item label=\"Terminal\">\n        <action name=\"Execute\">\n          <command>lxterminal</command>\n        </action>\n      </item>";}1' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    echo "Terminal entry added to the context menu."

    # Reconfigure Openbox to apply changes, need to set DISPLAY and XAUTHORITY for graphical operations
    export DISPLAY=:0
    export XAUTHORITY="$USER_HOME/.Xauthority"
    if openbox --reconfigure; then
        echo "Openbox configuration reloaded successfully."
    else
        echo "Failed to reload Openbox configuration. Check if Openbox is properly installed and running."
    fi
fi
