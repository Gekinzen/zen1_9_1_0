#!/usr/bin/env bash

STATE_FILE="$HOME/.config/waybar/scripts/power_mode_state"

# Create state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    mkdir -p "$(dirname "$STATE_FILE")"
    echo "balanced" > "$STATE_FILE"
fi

# Read current mode
MODE=$(cat "$STATE_FILE")

# Set icon, tooltip, and class based on mode
case "$MODE" in
    performance)
        ICON="󱓞"
        TOOLTIP="Performance Mode"
        CLASS="performance"
        ;;
    battery_saver)
        ICON="󰂃"
        TOOLTIP="Battery Saver"
        CLASS="battery_saver"
        ;;
    *)
        ICON="󰾅"
        TOOLTIP="Balanced Mode"
        CLASS="balanced"
        ;;
esac

# Output JSON for waybar
echo "{\"text\":\"$ICON\",\"tooltip\":\"$TOOLTIP\",\"class\":\"$CLASS\"}"