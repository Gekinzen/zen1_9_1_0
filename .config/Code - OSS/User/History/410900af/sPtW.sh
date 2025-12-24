#!/bin/bash

STATE_FILE="$HOME/.config/waybar/scripts/power_mode_state"

# Init default
if [ ! -f "$STATE_FILE" ]; then
    echo "balanced" > "$STATE_FILE"
fi

MODE=$(cat "$STATE_FILE")

if [ "$MODE" = "balanced" ]; then
    NEW_MODE="performance"
    notify-send "⚡ Performance Mode" "Maximum CPU Performance"
elif [ "$MODE" = "performance" ]; then
    NEW_MODE="battery_saver"
    notify-send "🔋 Battery Saver Mode" "Power Saving Enabled"
else
    NEW_MODE="balanced"
    notify-send "☁ Balanced Mode" "Normal Power Mode"
fi

echo "$NEW_MODE" > "$STATE_FILE"

# Reload only waybar module
pkill -SIGRTMIN+8 waybar
