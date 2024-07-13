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

# Read the current state, default to START if none found
STATE=$(cat $STATE_FILE 2>/dev/null || echo "START")

case $STATE in
    "START")
        log "Starting full setup..."
        log "Updating and upgrading system packages..."
        apt update && apt upgrade -y >> $LOG_FILE 2>&1
        echo "UPDATED" > $STATE_FILE
        log "System updated, a reboot is required to continue"
        # Set to automatically continue after reboot
        echo "@reboot root /path/to/bkad-ipfs.sh" >> /etc/cron.d/bkad-autoresume
        reboot
        ;;
    "UPDATED")
        log "Continuing setup after reboot..."
        # Remove cron job since it's no longer needed
        sed -i '/bkad-autoresume/d' /etc/cron.d/bkad-autoresume
        ./shortcut.sh >> $LOG_FILE 2>&1
        ./change_splash.sh >> $LOG_FILE 2>&1
        ./wallpaper03.sh >> $LOG_FILE 2>&1
        ./rm_wastebasket02.sh >> $LOG_FILE 2>&1
        ./taskbar.sh >> $LOG_FILE 2>&1
        ./034setup_ipfs.sh >> $LOG_FILE 2>&1
        ./bar.sh >> $LOG_FILE 2>&1
        echo "COMPLETED" > $STATE_FILE
        log "All configurations applied successfully!"
        log "Do you want to reboot now to apply all changes? (y/n): "
        read response
        if [[ "$response" == "y" || "$response" == "Y" ]]; then
            log "Rebooting now..."
            reboot
        else
            log "Please reboot your system manually to apply changes."
        fi
        ;;
    "COMPLETED")
        log "Setup was completed previously."
        ;;
    *)
        log "Unknown state: $STATE. Exiting..."
        exit 1
        ;;
esac
