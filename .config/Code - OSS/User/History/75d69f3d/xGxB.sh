#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
LOG_FILE="/tmp/nwg-dock.log"

start_dock() {
    mode="$1"

    # Kill existing instances and wait until fully closed
    pkill -f nwg-dock-hyprland 2>/dev/null
    sleep 0.5

    echo "Starting nwg-dock-hyprland in $mode mode..." | tee "$LOG_FILE"

    if [[ "$mode" == "tiling" ]]; then
        nwg-dock-hyprland -c "$CONFIG_DIR/config" -l overlay -x -nolauncher >>"$LOG_FILE" 2>&1 &
    else
        nwg-dock-hyprland -c "$CONFIG_DIR/config" -l overlay -nolauncher >>"$LOG_FILE" 2>&1 &
    fi

    # Wait a little for the dock to fully initialize
    sleep 0.5
}

toggle_dock() {
    if pgrep -f nwg-dock-hyprland > /dev/null; then
        pkill -f nwg-dock-hyprland
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
