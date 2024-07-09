#!/bin/bash

USER_HOME=/home/bitk1
USER_NAME=bitk1

# Ensure Waybar configuration directory exists
mkdir -p $USER_HOME/.config/waybar
chown $USER_NAME:$USER_NAME $USER_HOME/.config

# Waybar configuration JSON
cat > $USER_HOME/.config/waybar/config <<EOF
{
    "layer": "top",
    "position": "bottom",
    "height": 30,
    "modules-left": ["terminal"],
    "modules-center": [],
    "modules-right": [],
    "style": {
        "background": "#000000",
        "border-bottom": "2px solid #333333",
        "border-radius": 0
    }
}
EOF

# Waybar style CSS
cat > $USER_HOME/.config/waybar/style.css <<EOF
* {
    font-family: "sans-serif";
    font-size: 12px;
}

#terminal {
    padding: 0 10px;
    background-color: inherit;
    color: #FFFFFF;
}

#terminal:hover {
    background-color: #333333;
}
EOF

# Waybar terminal module JSON
cat > $USER_HOME/.config/waybar/modules/terminal <<EOF
{
    "format": " Terminal",
    "tooltip": "Open Terminal",
    "on-click": "lxterminal"
}
EOF

# Adjust permissions
chown -R $USER_NAME:$USER_NAME $USER_HOME/.config/waybar

# Restart Waybar if running
killall waybar
sudo -u $USER_NAME waybar &
