#!/bin/bash

# Update the package list
echo "Updating package list..."
sudo apt-get update

# Install Touchegg
echo "Installing Touchegg..."
sudo apt-get install -y touchegg

# Configuration directory setup
CONFIG_DIR="$HOME/.config/touchegg"
mkdir -p "$CONFIG_DIR"

# Create Touchegg configuration file
CONFIG_FILE="$CONFIG_DIR/touchegg.conf"
echo "Creating Touchegg configuration file..."

cat > "$CONFIG_FILE" << EOF
<touchégg>
    <settings>
        <property name="composed_gestures_time">0</property>
    </settings>
    <application name="All">
        <!-- Long press with one finger to simulate right click -->
        <gesture type="long_press" fingers="1" duration="500">
            <action type="mouse_click">BUTTON=3</action>
        </gesture>
    </application>
</touchégg>
EOF

echo "Touchegg has been configured to treat long press as a right-click."

# Start Touchegg
echo "Starting Touchegg..."
touchegg &

echo "Touchegg is now running. Long press should simulate a right-click."
