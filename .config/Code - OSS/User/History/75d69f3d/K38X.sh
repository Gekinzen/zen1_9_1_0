#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
LOG_FILE="/tmp/nwg-dock.log"
LOCK_FILE="/tmp/nwg-dock.lock"

# Get PRIMARY monitor by position, NOT by focus
get_primary_monitor() {
    # Always use leftmost monitor (lowest x position)
    local monitor=$(hyprctl monitors -j | jq -r 'sort_by(.x) | .[0].name')
    
    if [[ -z "$monitor" ]]; then
        monitor=$(hyprctl monitors -j | jq -r '.[0].name')
    fi
    
    echo "$monitor"
}

start_dock() {
    mode="$1"
    monitor="$2"
    
    # If no monitor specified, get primary by POSITION (not focus)
    if [[ -z "$monitor" ]]; then
        monitor=$(get_primary_monitor)
    fi
    
    echo "Target monitor: $monitor (primary by position)" | tee -a "$LOG_FILE"
    
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
    
    echo "Starting nwg-dock-hyprland in $mode mode on monitor $monitor at $(date)" | tee "$LOG_FILE"
    
    # Launch with specified monitor
    if [[ "$mode" == "tiling" ]]; then
        nwg-dock-hyprland -c "$CONFIG_DIR/config" -l overlay -x -nolauncher -o "$monitor" >>"$LOG_FILE" 2>&1 &
    else
        nwg-dock-hyprland -c "$CONFIG_DIR/config" -l overlay -nolauncher -o "$monitor" >>"$LOG_FILE" 2>&1 &
    fi
    
    # Wait for dock to initialize
    sleep 0.7
    
    # Remove lock file
    rm -f "$LOCK_FILE"
    
    # Verify it started
    if pgrep -f "nwg-dock-hyprland" > /dev/null; then
        echo "✓ Dock started successfully on $monitor" | tee -a "$LOG_FILE"
    else
        echo "✗ Warning: Dock may not have started properly" | tee -a "$LOG_FILE"
    fi
}

toggle_dock() {
    if pgrep -f nwg-dock-hyprland > /dev/null; then
        pkkg -9 -f nwg-dock-hyprland
        rm -f "$LOCK_FILE"
    else
        start_dock "tiling"
    fi
}

case "$1" in
    tiling)
        start_dock "tiling" "$2"
        ;;
    float)
        start_dock "float" "$2"
        ;;
    toggle)
        toggle_dock
        ;;
    *)
        start_dock "tiling" "$2"
        ;;
esac