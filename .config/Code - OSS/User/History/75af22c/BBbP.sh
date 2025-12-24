#!/bin/bash

CHOICE=$(echo -e "⚠️ WARNING: You are about to Suspend\n\n✓ Yes, proceed with Suspend\n✗ No, cancel" | \
    wofi --dmenu \
    --prompt "⚠️  Confirm Action" \
    --width 500 \
    --height 250 \
    --style ~/.config/wofi/menu-style.css)

if [[ "$CHOICE" == "✓ Yes, proceed with Suspend" ]]; then
    # hypridle will auto-lock via before_sleep_cmd
    systemctl suspend
else
    notify-send "Cancelled" "Suspend cancelled" -i dialog-information
fi