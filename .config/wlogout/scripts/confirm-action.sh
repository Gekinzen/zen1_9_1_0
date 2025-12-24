#!/bin/bash

ACTION="$1"
ACTION_LABEL="$2"
ACTION_COMMAND="$3"

# Create confirmation dialog
CHOICE=$(echo -e "✓ Yes, $ACTION_LABEL\n✗ Cancel" | \
    wofi --dmenu \
    --prompt "⚠️  Confirm $ACTION_LABEL?" \
    --width 400 \
    --height 180 \
    --style ~/.config/wofi/menu-style.css)

if [[ "$CHOICE" == "✓ Yes, $ACTION_LABEL" ]]; then
    # Execute the action
    eval "$ACTION_COMMAND"
else
    notify-send "Cancelled" "$ACTION_LABEL cancelled" -i dialog-information
fi
