#!/bin/bash

mode="$1"
current_fullscreen=$(hyprctl activewindow -j | jq -r '.fullscreen')

if [[ "$mode" == "maximize" ]]; then
    # Maximize fullscreen (Super+F) - mode 1
    hyprctl dispatch fullscreen 1
    
elif [[ "$mode" == "full" ]]; then
    # True fullscreen (Super+Shift+F) - mode 0 (real fullscreen)
    hyprctl dispatch fullscreen 0
fi