#!/bin/bash

# Define the Desktop directory and shortcut file
DESKTOP_DIR="$HOME/Desktop"
SHORTCUT_FILE="$DESKTOP_DIR/Terminal.desktop"  # The file ends with .desktop to function, but the name field controls display

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
