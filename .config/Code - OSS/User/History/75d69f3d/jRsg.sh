#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
LOG_FILE="/tmp/nwg-dock.log"
DOCK_PID=$(pgrep -f nwg-dock-hyprland)

start_dock() {
    mode="$1"
    pkill -f nwg-dock-hyprland

    if [[ "$mode" == "tiling" ]]; then
        echo "🧱 Launching dock in tiling mode (with -x)" | tee "$LOG_FILE"
        nwg-dock-hyprland  -c  "$CONFIG_DIR/config" -l overlay -x -nolauncher >>"$LOG_FILE" 2>&1 &
    else
        echo "🌊 Launching dock in floating mode (no -x)" | tee "$LOG_FILE"
        nwg-dock-hyprland  -c  "$CONFIG_DIR/config" -l overlay -nolauncher >>"$LOG_FILE" 2>&1 &
    fi
}

toggle_dock() {
    if [[ -n "$DOCK_PID" ]]; then
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
