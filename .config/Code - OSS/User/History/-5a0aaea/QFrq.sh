#!/bin/bash

CHOICE=$(echo -e "⚠️ WARNING: You are about to Hibernate\n\n✓ Yes, proceed with Hibernate\n✗ No, cancel" | \
    wofi --dmenu \
    --prompt "⚠️  Confirm Action" \
    --width 500 \
    --height 250 \
    --style ~/.config/wofi/menu-style.css)

if [[ "$CHOICE" == "✓ Yes, proceed with Hibernate" ]]; then
    # Lock screen first (force it)
    hyprlock &
    LOCK_PID=$!
    
    # Wait for lock to fully engage
    sleep 2
    
    # Hibernate
    systemctl hibernate
    
    # After resume, ensure lock is still there
    wait $LOCK_PID
else
    notify-send "Cancelled" "Hibernate cancelled" -i dialog-information
fi