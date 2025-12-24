#!/bin/bash

STATE_FILE="$HOME/.config/waybar/power_mode_state"

# Initialize state if not exists
if [ ! -f "$STATE_FILE" ]; then
    echo "balanced" > "$STATE_FILE"
fi

CURRENT_MODE=$(cat "$STATE_FILE")

# Detect running games
is_game_running() {
    pgrep -x "steam" >/dev/null && return 0
    pgrep -f "steam_appid" >/dev/null && return 0
    pgrep -f "Proton" >/dev/null && return 0
    pgrep -f "wine" >/dev/null && return 0
    pgrep -x "gamescope" >/dev/null && return 0
    pgrep -f "dxvk" >/dev/null && return 0
    pgrep -f "vkd3d" >/dev/null && return 0
    return 1
}

# Cycle modes
case "$CURRENT_MODE" in
    "balanced")
        if is_game_running; then
            NEW_MODE="balanced"  # prevent aggressive performance during game
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

# Save new state
echo "$NEW_MODE" > "$STATE_FILE"

# Apply actual power mode (example: CPU governor + brightness)
case "$NEW_MODE" in
    "performance")
        if ! is_game_running; then
            sudo cpupower frequency-set -g performance
        fi
        xbacklight -set 100
        COLOR="#FF5555"
        ;;
    "balanced")
        sudo cpupower frequency-set -g ondemand
        xbacklight -set 75
        COLOR="#50FA7B"
        ;;
    "battery_saver")
        sudo cpupower frequency-set -g powersave
        xbacklight -set 50
        COLOR="#8BE9FD"
        ;;
esac

# Notify user of mode change
if command -v swaync-client >/dev/null 2>&1; then
    swaync-client -t "Power Mode" -m "Switched to $NEW_MODE mode"
else
    notify-send "Power Mode" "Switched to $NEW_MODE mode"
fi

# Trigger Waybar refresh
pkill -SIGRTMIN+10 waybar
