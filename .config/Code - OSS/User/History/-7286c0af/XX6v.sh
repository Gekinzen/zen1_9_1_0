#!/bin/bash

STATE_FILE="$HOME/.config/waybar/scripts/power_mode_state"

# Init default
if [ ! -f "$STATE_FILE" ]; then
    echo "balanced" > "$STATE_FILE"
fi

MODE=$(cat "$STATE_FILE")

case "$MODE" in
    performance)
        ICON="⚡"
        CLASS="performance"
        TOOLTIP="Performance Mode"
        ;;
    balanced)
        ICON="☁"
        CLASS="balanced"
        TOOLTIP="Balanced Mode"
        ;;
    battery_saver)
        ICON="🔋"
        CLASS="battery_saver"
        TOOLTIP="Battery Saver Mode"
        ;;
    *)
        ICON="☁"
        CLASS="balanced"
        TOOLTIP="Balanced Mode"
        ;;
esac

echo "{\"icon\":\"$ICON\",\"tooltip\":\"$TOOLTIP\",\"class\":\"$CLASS\"}"
