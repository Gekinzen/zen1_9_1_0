#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyperbars.conf"
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Load config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    GLASS_ENABLED=true
fi

# Toggle glass effect
if [ "$GLASS_ENABLED" = "true" ]; then
    # Disable glass (solid background)
    sed -i 's/GLASS_ENABLED=.*/GLASS_ENABLED=false/' "$CONFIG_FILE"
    
    # Change to opaque (ff = 100%)
    source ~/.cache/wal/colors.sh
    BG="${background#\#}"
    sed -i "s/bar_color = rgba([^)]*)/bar_color = rgba(${BG}ff)/" "$HYPR_CONFIG"
    
    notify-send "󰖲 Glass Effect" "Disabled - Solid background" -i window
else
    # Enable glass (transparent background)
    sed -i 's/GLASS_ENABLED=.*/GLASS_ENABLED=true/' "$CONFIG_FILE"
    
    # Apply glass effect
    ~/.config/hypr/scripts/update-hyprbars-glass.sh
    
    notify-send "󰖲 Glass Effect" "Enabled - Premium blur" -i window
fi

hyprctl reload
