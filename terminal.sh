#!/bin/bash

# Define the Desktop directory and shortcut file
DESKTOP_DIR="$HOME/Desktop"
SHORTCUT_FILE="$DESKTOP_DIR/terminal.desktop"

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
