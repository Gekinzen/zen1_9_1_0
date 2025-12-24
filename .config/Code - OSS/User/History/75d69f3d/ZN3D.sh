#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
LOG_FILE="/tmp/nwg-dock.log"
LOCK_FILE="/tmp/nwg-dock.lock"

start_dock() {
    mode="$1"
    
    # Prevent multiple simultaneous launches
    if [ -f "$LOCK_FILE" ]; then
        echo "Dock is already starting, please wait..." | tee -a "$LOG_FILE"
        return 1
    fi
    
    touch "$LOCK_FILE"
    
    # Kill existing instances thoroughly
    pkill -9 -f nwg-dock-hyprland 2>/dev/null
    killall -9 nwg-dock-hyprland 2>/dev/null
    
    # Wait until completely dead
    for i in {1..20}; do
        if ! pgrep -f "nwg-dock-hyprland" > /dev/null; then
            break
        fi
        sleep 0.1
    done
    
    # Final check
    if pgrep -f "nwg-dock-hyprland" > /dev/null; then
        echo "Warning: Previous dock instance still running" | tee -a "$LOG_FILE"
        pkill -9 -f nwg-dock-hyprland
        sleep 0.3
    fi
    
    echo "Starting nwg-dock-hyprland in $mode mode at $(date)" | tee "$LOG_FILE"
    
    if [[ "$mode" == "tiling" ]]; then
        nwg-dock-hyprland -c "$CONFIG_DIR/config" -l overlay -x -nolauncher >>"$LOG_FILE" 2>&1 &
    else
        nwg-dock-hyprland -c "$CONFIG_DIR/config" -l overlay -nolauncher >>"$LOG_FILE" 2>&1 &
    fi
    
    # Wait for dock to initialize
    sleep 0.7
    
    # Remove lock file
    rm -f "$LOCK_FILE"
    
    # Verify it started
    if pgrep -f "nwg-dock-hyprland" > /dev/null; then
        echo "Dock started successfully" | tee -a "$LOG_FILE"
    else
        echo "Warning: Dock may not have started properly" | tee -a "$LOG_FILE"
    fi
}

toggle_dock() {
    if pgrep -f nwg-dock-hyprland > /dev/null; then
        pkill -9 -f nwg-dock-hyprland
        rm -f "$LOCK_FILE"
    else
        start_dock "tiling"
    fi
}

case "$1" in
    tiling)
        start_dock "tiling"
        ;;
    float)
        start_dock "float"
        ;;
    toggle)
        toggle_dock
        ;;
    *)
        start_dock "tiling"
        ;;
esac