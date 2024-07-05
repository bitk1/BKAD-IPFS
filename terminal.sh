#!/bin/bash

# Determine correct home directory based on whether the script is run with 'sudo'
if [ "$SUDO_USER" ]; then
    HOME_DIR=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    HOME_DIR=$HOME
fi

DESKTOP_DIR="$HOME_DIR/Desktop"
SHORTCUT_FILE="$DESKTOP_DIR/Terminal.desktop"

# Ensure the Desktop directory exists
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
Terminal=false
StartupNotify=false
EOF

# Make the shortcut executable
chmod +x "$SHORTCUT_FILE"

echo "Shortcut for Terminal created on the desktop."
