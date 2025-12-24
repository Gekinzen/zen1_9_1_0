#!/bin/bash

CHOICE=$(echo -e "⚠️ WARNING: You are about to Suspend\n\n✓ Yes, proceed with Suspend\n✗ No, cancel" | \
    wofi --dmenu \
    --prompt "⚠️  Confirm Action" \
    --width 500 \
    --height 250 \
    --style ~/.config/wofi/menu-style.css)

if [[ "$CHOICE" == "✓ Yes, proceed with Suspend" ]]; then
    # Lock screen first (force it)
    hyprlock &
    LOCK_PID=$!
    
    # Wait for lock to fully engage
    sleep 2
    
    # Suspend
    systemctl suspend
    
    # After resume, ensure lock is still there
    wait $LOCK_PID
else
    notify-send "Cancelled" "Suspend cancelled" -i dialog-information
fi