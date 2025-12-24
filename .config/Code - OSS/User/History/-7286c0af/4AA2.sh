#!/bin/bash

STATE_FILE="$HOME/.config/waybar/power_mode_state"

# Default state
if [ ! -f "$STATE_FILE" ]; then
    echo "balanced" > "$STATE_FILE"
fi

MODE=$(cat "$STATE_FILE")

case "$MODE" in
    "performance")
        ICON="✔"
        COLOR="#FF5555"
        TEXT="Performance Mode"
        ;;
    "balanced")
        ICON="✔"
        COLOR="#50FA7B"
        TEXT="Balanced Mode"
        ;;
    "battery_saver")
        ICON="✔"
        COLOR="#8BE9FD"
        TEXT="Battery Saver Mode"
        ;;
    *)
        ICON="✔"
        COLOR="#FFFFFF"
        TEXT="Unknown Mode"
        ;;
esac

# Output JSON for Waybar
echo "{\"text\":\"$ICON\",\"tooltip\":\"$TEXT\",\"class\":\"$MODE\",\"percentage\":0}"
