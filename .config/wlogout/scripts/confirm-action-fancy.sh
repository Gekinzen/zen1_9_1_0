#!/bin/bash

ACTION="$1"
ACTION_LABEL="$2"
ACTION_COMMAND="$3"

# Icon based on action
case "$ACTION" in
    "logout") ICON="system-log-out" ;;
    "reboot") ICON="system-reboot" ;;
    "shutdown") ICON="system-shutdown" ;;
    "suspend") ICON="system-suspend" ;;
    "hibernate") ICON="system-hibernate" ;;
    *) ICON="dialog-warning" ;;
esac

# Create detailed confirmation
CHOICE=$(echo -e "⚠️ WARNING: You are about to $ACTION_LABEL\n\n✓ Yes, proceed with $ACTION_LABEL\n✗ No, cancel" | \
    wofi --dmenu \
    --prompt "⚠️  Confirm Action" \
    --width 500 \
    --height 250 \
    --style ~/.config/wofi/menu-style.css)

if [[ "$CHOICE" == "✓ Yes, proceed with $ACTION_LABEL" ]]; then
    # Show countdown notification
    notify-send "⚠️  $ACTION_LABEL" "Executing in 3 seconds..." -t 1000 -i "$ICON" -u critical
    sleep 1
    notify-send "⚠️  $ACTION_LABEL" "Executing in 2 seconds..." -t 1000 -i "$ICON" -u critical
    sleep 1
    notify-send "⚠️  $ACTION_LABEL" "Executing in 1 second..." -t 1000 -i "$ICON" -u critical
    sleep 1
    
    # Execute the action
    eval "$ACTION_COMMAND"
else
    notify-send "Cancelled" "$ACTION_LABEL cancelled" -i dialog-information
fi
