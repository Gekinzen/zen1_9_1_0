#!/bin/bash

while true; do
    window_info=$(hyprctl -j activewindow)
    fullscreen=$(echo "$window_info" | jq -r '.fullscreen')
    
    # fullscreen values:
    # 0 = true fullscreen (covers everything)
    # 1 = maximize fullscreen (respects reserved space)
    # false = not fullscreen
    
    if [[ "$fullscreen" == "0" ]]; then
        # True fullscreen - hide everything
        pkill -STOP waybar 2>/dev/null
        pkill -STOP nwg-dock-hyprland 2>/dev/null
    elif [[ "$fullscreen" == "1" ]]; then
        # Maximize - show dock/waybar
        pkill -CONT waybar 2>/dev/null
        pkill -CONT nwg-dock-hyprland 2>/dev/null
    else
        # Not fullscreen - show everything
        pkill -CONT waybar 2>/dev/null
        pkill -CONT nwg-dock-hyprland 2>/dev/null
    fi
    
    sleep 0.3
done