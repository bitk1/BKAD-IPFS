#!/bin/bash
#v02
# Define the path to the new wallpaper image
WALLPAPER="/home/bitk1/BKAD-IPFS/wallpaper.png"

# Check if the wallpaper file exists
if [ ! -f "$WALLPAPER" ]; then
    echo "Error: Wallpaper file does not exist at $WALLPAPER"
    exit 1
fi

# Set up the desktop configuration directory for pcmanfm
CONFIG_DIR="$HOME/.config/pcmanfm/LXDE-pi"
mkdir -p "$CONFIG_DIR"

# Configure wallpaper settings for LXDE-pi profile
CONFIG_FILE="$CONFIG_DIR/desktop-items-0.conf"

# Create or modify pcmanfm configuration to set the wallpaper
{
    echo "[*]"
    echo "wallpaper_mode=center"  # Set the wallpaper mode to 'center'
    echo "wallpaper=$WALLPAPER"   # Path to the wallpaper image
    echo "desktop_bg=#000000"     # Set desktop background color to black
    echo "desktop_fg=#ffffff"     # Set desktop foreground color to white (for icons)
    echo "desktop_shadow=#000000" # Set desktop icon shadow color to black
    echo "desktop_font=Sans 12"   # Example: Set desktop font (adjust as needed)
} > "$CONFIG_DIR/desktop-items-0.conf"

# Check for DISPLAY environment variable
if [ -z "$DISPLAY" ]; then
    echo "No DISPLAY variable set. Cannot configure wallpaper using pcmanfm without a graphical session."
    exit 1
fi

# Use pcmanfm to apply the wallpaper settings
pcmanfm --reconfigure --profile LXDE-pi

echo "Wallpaper changed successfully to $WALLPAPER with a black background."
