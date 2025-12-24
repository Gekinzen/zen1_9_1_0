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
        APP_NAME="power-mode-performance"
        ;;
    performance)
        NEW="battery_saver"
        MSG="Battery Saver Mode"
        ICON="󰂃"
        APP_NAME="power-mode-battery"
        ;;
    *)
        NEW="balanced"
        MSG="Balanced Mode"
        ICON="󰾅"
        APP_NAME="power-mode-balanced"
        ;;
esac

# Save new mode
echo "$NEW" > "$STATE_FILE"

# Send styled notification using app-name for CSS targeting
notify-send "Power Mode" "$ICON $MSG Activated" -a "$APP_NAME"

# Signal waybar to refresh
pkill -SIGRTMIN+9 waybar