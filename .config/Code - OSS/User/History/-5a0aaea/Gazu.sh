#!/bin/bash

CHOICE=$(echo -e "⚠️ WARNING: You are about to Hibernate\n\n✓ Yes, proceed with Hibernate\n✗ No, cancel" | \
    wofi --dmenu \
    --prompt "⚠️  Confirm Action" \
    --width 500 \
    --height 250 \
    --style ~/.config/wofi/menu-style.css)

if [[ "$CHOICE" == "✓ Yes, proceed with Hibernate" ]]; then
    # hypridle will auto-lock via before_sleep_cmd
    systemctl hibernate
else
    notify-send "Cancelled" "Hibernate cancelled" -i dialog-information
fi