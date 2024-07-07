#!/bin/bash

# Updating system and installing necessary packages
echo "Updating package list and installing necessary build tools and libraries..."
sudo apt-get update
sudo apt-get install -y git cmake g++ libinput-dev libgtk-3-dev libqt5x11extras5-dev qttools5-dev qttools5-dev-tools libqt5svg5-dev

# Cloning Touchegg repository
echo "Cloning Touchegg from GitHub..."
git clone https://github.com/JoseExposito/touchegg.git

# Navigating to the Touchegg directory and compiling the source
echo "Compiling Touchegg..."
cd touchegg
cmake .
make

# Installing Touchegg
echo "Installing Touchegg..."
sudo make install

# Creating configuration file for Touchegg
echo "Creating Touchegg configuration..."
CONFIG_DIR="$HOME/.config/touchegg"
mkdir -p "$CONFIG_DIR"
CONFIG_FILE="$CONFIG_DIR/touchegg.conf"

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

# Inform user of completion
echo "Touchegg installation and configuration complete. You can start it by running 'touchegg &'."
