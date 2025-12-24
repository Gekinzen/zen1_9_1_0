#!/bin/bash

STATE_FILE="$HOME/.config/waybar/power_mode_state"

# Init state
if [ ! -f "$STATE_FILE" ]; then
    echo "balanced" > "$STATE_FILE"
fi

CURRENT_MODE=$(cat "$STATE_FILE")

# GAME DETECTION
is_game_running() {
    pgrep -x "steam" >/dev/null && return 0
    pgrep -f "steam_appid" >/dev/null && return 0
    pgrep -f "Proton" >/dev/null && return 0
    pgrep -f "wine" >/dev/null && return 0
    pgrep -x "gamescope" >/dev/null && return 0
    return 1
}

# CYCLE MODES
case "$CURRENT_MODE" in
    "balanced")
        if is_game_running; then
            NEW_MODE="balanced"
        else
            NEW_MODE="performance"
        fi
        ;;
    "performance")
        NEW_MODE="battery_saver"
        ;;
    "battery_saver")
        NEW_MODE="balanced"
        ;;
    *)
        NEW_MODE="balanced"
        ;;
esac

# SAVE MODE
echo "$NEW_MODE" > "$STATE_FILE"

# APPLY POWER MODE (NO SUDO)
case "$NEW_MODE" in
    "performance")
        powerprofilesctl set performance
        brightnessctl set 100%
        COLOR="#FF5555"
        ICON="Performance"
        ;;
    "balanced")
        powerprofilesctl set balanced
        brightnessctl set 75%
        COLOR="#50FA7B"
        ICON="Balanced"
        ;;
    "battery_saver")
        powerprofilesctl set power-saver
        brightnessctl set 50%
        COLOR="#8BE9FD"
        ICON="Battery Saver"
        ;;
esac

# NOTIFICATION
if command -v swaync-client >/dev/null; then
    swaync-client -t "Power Mode" -m "Switched to $ICON mode"
else
    notify-send "Power Mode" "Switched to $ICON mode"
fi

# REFRESH WAYBAR
pkill -SIGRTMIN+10 waybar
