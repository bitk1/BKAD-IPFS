#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Install Waybar and dependencies
echo "Installing Waybar and its dependencies..."
apt-get update
apt-get install -y waybar

# User setup (replace 'bitk1' with your actual username if different)
USER_HOME=/home/bitk1
USER_NAME=bitk1

# Configuration directories setup
echo "Setting up configuration directories for Waybar..."
mkdir -p $USER_HOME/.config/waybar
mkdir -p $USER_HOME/.config/autostart

# Create Waybar's configuration JSON file
echo "Creating Waybar configuration files..."
cat > $USER_HOME/.config/waybar/config <<EOF
{
    "layer": "top",
    "position": "bottom",
    "height": 30,
    "modules-left": ["custom/terminal"],
    "modules-center": [],
    "modules-right": [],
    "style": {
        "background": "#000000",
        "border-bottom": "2px solid #333333",
        "border-radius": 0
    }
}
EOF

# Create a style CSS for Waybar
cat > $USER_HOME/.config/waybar/style.css <<EOF
* {
    font-family: "sans-serif";
    font-size: 12px;
}

#custom-terminal {
    padding: 0 10px;
    background-color: inherit;
    color: #FFFFFF;
}

#custom-terminal:hover {
    background-color: #333333;
}
EOF

# Create the module for launching a terminal
mkdir -p $USER_HOME/.config/waybar/modules
cat > $USER_HOME/.config/waybar/modules/terminal.json <<EOF
{
    "format": " Terminal",
    "tooltip": "Click to open terminal",
    "on-click": "lxterminal"
}
EOF

# Adjust ownership to the correct user
chown -R $USER_NAME:$USER_NAME $USER_HOME/.config/waybar

# Setup Waybar to start on login
cat > $USER_HOME/.config/autostart/waybar.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Waybar
Exec=waybar
X-GNOME-Autostart-enabled=true
EOF

chown $USER_NAME:$USER_NAME $USER_HOME/.config/autostart/waybar.desktop

echo "Waybar setup complete. Waybar should now be running with a custom terminal launcher after login."
