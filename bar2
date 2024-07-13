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
mkdir -p $USER_HOME/.config/waybar/modules

# Ensure directory creation
if [ ! -d "$USER_HOME/.config/waybar/modules" ]; then
    echo "Failed to create necessary directories."
    exit 1
fi

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
cat > $USER_HOME/.config/waybar/modules/terminal.json <<EOF
{
    "format": " Terminal",
    "tooltip": "Click to open terminal",
    "on-click": "lxterminal"
}
EOF

# Adjust ownership to the correct user
chown -R $USER_NAME:$USER_NAME $USER_HOME/.config/waybar

# Restart Waybar if it's running
echo "Reloading Waybar..."
killall -u $USER_NAME waybar 2>/dev/null
sudo -u $USER_NAME waybar &

echo "Waybar setup complete. Waybar should now be running with a custom terminal launcher."
