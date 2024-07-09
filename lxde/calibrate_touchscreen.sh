#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

echo "Installing necessary tools..."
apt-get update
apt-get install -y xinput xinput_calibrator

echo "Listing input devices..."
xinput --list

echo "Please identify the touchscreen device from the list above."
echo "Enter the device name exactly as listed (e.g., '7inch Capacitive TouchScreen'): "
read touchscreen_device

# Start calibration
echo "Starting calibration for $touchscreen_device..."
xinput_calibrator --device "$touchscreen_device"

echo "Follow the on-screen instructions to calibrate the touchscreen."
