#!/usr/bin/env bash

STATE_FILE="$HOME/.config/waybar/scripts/power_mode_state"

[ ! -f "$STATE_FILE" ] && echo "balanced" > "$STATE_FILE"

MODE=$(cat "$STATE_FILE")

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

echo "$NEW" > "$STATE_FILE"

swaync-client -n -t "$MSG Activated"
pkill -SIGRTMIN+9 waybar
