#!/usr/bin/env bash

STATE_FILE="$HOME/.config/waybar/scripts/power_mode_state"

# Create state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    mkdir -p "$(dirname "$STATE_FILE")"
    echo "balanced" > "$STATE_FILE"
fi

# Read current mode
MODE=$(cat "$STATE_FILE")

# Toggle to next mode with icons and colors
case "$MODE" in
    balanced)
        NEW="performance"
        MSG="Performance Mode"
        ICON="󱓞"
        URGENCY="critical"  # Red-ish appearance
        ;;
    performance)
        NEW="battery_saver"
        MSG="Battery Saver Mode"
        ICON="󰂃"
        URGENCY="low"  # Blue-ish appearance
        ;;
    *)
        NEW="balanced"
        MSG="Balanced Mode"
        ICON="󰾅"
        URGENCY="normal"  # Green-ish appearance
        ;;
esac

# Save new mode
echo "$NEW" > "$STATE_FILE"

# Send styled notification via swaync
swaync-client -t "$MSG Activated" -b "$ICON $MSG" -u "$URGENCY" -i "power-profile-$NEW"

# Signal waybar to refresh
pkill -SIGRTMIN+9 waybar