#!/bin/bash
# setup_runtime_dir.sh
# Ensures that XDG_RUNTIME_DIR is set correctly for user operations

# Log file location
log_file="/var/log/setup_runtime_dir.log"

# Function to append messages to a log file
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $log_file
}

# Check if the script is running as root
if [ "$(id -u)" -ne 0 ]; then
    log "This script must be run as root."
    exit 1
fi

# Get the currently active username, not just the user who initiated sudo
current_user=$(logname 2>/dev/null || echo $SUDO_USER)
if [ -z "$current_user" ]; then
    log "Failed to determine the active user."
    exit 1
fi

# Setup the XDG_RUNTIME_DIR if not already set
if [ -z "${XDG_RUNTIME_DIR}" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u $current_user)"
    mkdir -p "${XDG_RUNTIME_DIR}"
    chown $current_user:$current_user "${XDG_RUNTIME_DIR}"
    chmod 0700 "${XDG_RUNTIME_DIR}"
    log "XDG_RUNTIME_DIR set to ${XDG_RUNTIME_DIR}"
else
    log "XDG_RUNTIME_DIR is already set to ${XDG_RUNTIME_DIR}"
fi

echo "Setup complete."
