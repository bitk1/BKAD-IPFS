#!/bin/bash

# Determine the correct user and desktop directory
if [[ -n $SUDO_USER ]]; then
    # Script was invoked with sudo
    HOME_DIR=$(getent passwd $SUDO_USER | cut -d: -f6)
else
    # Script was not invoked with sudo
    HOME_DIR=$HOME
fi

DESKTOP_DIR="$HOME_DIR/Desktop"
SHORTCUT_FILE="$DESKTOP_DIR/terminal.desktop"

# Create the Desktop directory if it doesn't exist
mkdir -p "$DESKTOP_DIR"

# Create the shortcut file
cat > "$SHORTCUT_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Comment=Open a Terminal
Icon=utilities-terminal
Exec=lxterminal
Path=
Terminal=false
StartupNotify=false
EOF

# Make the shortcut executable
chmod +x "$SHORTCUT_FILE"

echo "Shortcut for terminal created on the desktop."
