#!/bin/bash

while true; do
    window_info=$(hyprctl -j activewindow)
    fullscreen=$(echo "$window_info" | jq -r '.fullscreen')
    
    # Check if fullscreen is enabled (0 = none, 1 = maximize, 2 = true fullscreen)
    if [[ "$fullscreen" != "0" && "$fullscreen" != "false" ]]; then
        # Hide waybar and dock
        pkill -STOP waybar 2>/dev/null
        pkill -STOP nwg-dock-hyprland 2>/dev/null
    else
        # Show waybar and dock
        pkill -CONT waybar 2>/dev/null
        pkill -CONT nwg-dock-hyprland 2>/dev/null
    fi
    
    sleep 0.5  # Mas mabilis na check
done