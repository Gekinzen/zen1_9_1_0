#!/usr/bin/env bash

STATE_FILE="$HOME/.config/waybar/scripts/power_mode_state"

# Create state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    mkdir -p "$(dirname "$STATE_FILE")"
    echo "balanced" > "$STATE_FILE"
fi

# Read current mode
MODE=$(cat "$STATE_FILE")

# Toggle to next mode
case "$MODE" in
    balanced)
        NEW="performance"
        MSG="Performance Mode"
        ;;
    performance)
        NEW="battery_saver"
        MSG="Battery Saver Mode"
        ;;
    *)
        NEW="balanced"
        MSG="Balanced Mode"
        ;;
esac

# Save new mode
echo "$NEW" > "$STATE_FILE"

# Send notification
notify-send "Power Mode" "$MSG Activated" -t 2000

# Signal waybar to refresh
pkill -SIGRTMIN+9 waybar