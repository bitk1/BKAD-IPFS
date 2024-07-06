#!/bin/bash

# Install Touchegg if not already installed
if ! which touchegg > /dev/null; then
    echo "Installing Touchegg..."
    sudo apt-get update
    sudo apt-get install -y touchegg
else
    echo "Touchegg is already installed."
fi

# Configuration for Touchegg (assuming default config location and structure)
CONFIG_DIR="$HOME/.config/touchegg"
mkdir -p "$CONFIG_DIR"
CONFIG_FILE="$CONFIG_DIR/touchegg.conf"

echo "Creating Touchegg configuration..."
cat > "$CONFIG_FILE" << EOF
<touchégg>
    <settings>
        <property name="composed_gestures_time">0</property>
    </settings>
    <application name="All">
        <gesture type="tap" fingers="1" direction="none">
            <action type="click">BUTTON=3</action>
        </gesture>
    </application>
</touchégg>
EOF

# Start Touchegg
echo "Starting Touchegg..."
touchegg &
echo "Touchegg configuration completed and service started."
