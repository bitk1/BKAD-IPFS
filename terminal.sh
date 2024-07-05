#!/bin/bash

# Define the Desktop directory and shortcut file
DESKTOP_DIR="$HOME/Desktop"
SHORTCUT_FILE="$DESKTOP_DIR/Terminal.desktop"  # The file needs to end with .desktop to function

# Create the shortcut file
cat > "$SHORTCUT_FILE" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal  # This is the name that will appear under the icon
Comment=Open a Terminal
Icon=utilities-terminal
Exec=lxterminal
Path=
Terminal=false
StartupNotify=false
EOF

# Make the shortcut executable
chmod +x "$SHORTCUT_FILE"

echo "Shortcut for Terminal created on the desktop."
