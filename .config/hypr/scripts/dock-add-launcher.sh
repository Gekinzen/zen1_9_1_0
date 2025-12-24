#!/bin/bash

PINNED_FILE="$HOME/.config/nwg-dock-hyprland/pinned"

# Create pinned file if doesn't exist
if [ ! -f "$PINNED_FILE" ]; then
    touch "$PINNED_FILE"
fi

# Check if launcher already exists
if ! grep -q "rofi-app-launcher" "$PINNED_FILE"; then
    # Add launcher as first item
    TEMP_FILE=$(mktemp)
    echo "rofi;$HOME/.config/hypr/scripts/rofi-app-launcher.sh;applications-system" > "$TEMP_FILE"
    cat "$PINNED_FILE" >> "$TEMP_FILE"
    mv "$TEMP_FILE" "$PINNED_FILE"
    
    notify-send "󰘔 Dock" "Launcher added" -t 2000
fi

# Restart dock
pkill -9 nwg-dock-hyprland
sleep 0.3
~/.config/hypr/scripts/dock-manager.sh start
