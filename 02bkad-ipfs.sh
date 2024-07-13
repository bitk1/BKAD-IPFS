#!/bin/bash

LOG_FILE="/var/log/bkad-ipfs-setup.log"
STATE_FILE="/var/tmp/bkad-ipfs-state"

# Function to log messages
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOG_FILE
}

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
    log "This script must be run as root"
    exit 1
fi

# Initialize state
if [ ! -f $STATE_FILE ]; then
    echo "START" > $STATE_FILE
fi

STATE=$(cat $STATE_FILE)

case $STATE in
    "START")
        log "Starting full setup..."
        log "Updating and upgrading system packages..."
        apt update && apt upgrade -y >> $LOG_FILE 2>&1
        echo "UPDATED" > $STATE_FILE
        log "System updated, a reboot is required to continue"
        reboot
        ;;
    "UPDATED")
        log "Continuing setup after reboot..."
        log "Running shortcut setup..."
        ./shortcut.sh >> $LOG_FILE 2>&1
        log "Changing splash screen..."
        ./change_splash.sh >> $LOG_FILE 2>&1
        log "Updating wallpaper..."
        ./wallpaper03.sh >> $LOG_FILE 2>&1
        log "Removing wastebasket icon..."
        ./rm_wastebasket02.sh >> $LOG_FILE 2>&1
        log "Configuring taskbar..."
        ./taskbar.sh >> $LOG_FILE 2>&1
        log "Setting up IPFS..."
        ./034setup_ipfs.sh >> $LOG_FILE 2>&1
        log "Configuring Waybar..."
        ./bar.sh >> $LOG_FILE 2>&1
        echo "COMPLETED" > $STATE_FILE
        log "All configurations applied successfully!"
        ;;
    "COMPLETED")
        log "Setup was completed previously."
        ;;
esac

# Offer to reboot
log "Do you want to reboot now to apply all changes? (y/n): "
read response
if [[ "$response" == "y" || "$response" == "Y" ]]; then
    log "Rebooting now..."
    reboot
else
    log "Please reboot your system manually to apply changes."
fi
