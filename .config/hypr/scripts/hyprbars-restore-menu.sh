#!/bin/bash

# Get list of windows in special:minimized workspace
WINDOWS=$(hyprctl clients -j | jq -r '.[] | select(.workspace.name == "special:minimized") | "[\(.class)] \(.title)"')

if [ -z "$WINDOWS" ]; then
    notify-send "󰖰 Minimized Windows" "No minimized windows" -i window
    exit 0
fi

# Show rofi menu
CHOICE=$(echo "$WINDOWS" | rofi -dmenu -i -p "󰖰 Restore Window" -theme ~/.config/rofi/power-menu.rasi)

if [ -n "$CHOICE" ]; then
    # Get window address
    WINDOW_TITLE=$(echo "$CHOICE" | sed 's/\[.*\] //')
    ADDRESS=$(hyprctl clients -j | jq -r ".[] | select(.title == \"$WINDOW_TITLE\") | .address")
    
    if [ -n "$ADDRESS" ]; then
        # Move window back to current workspace
        hyprctl dispatch movetoworkspace "$(hyprctl activeworkspace -j | jq -r '.id'),address:$ADDRESS"
        hyprctl dispatch focuswindow "address:$ADDRESS"
        notify-send "󰖰 Window" "Restored" -t 1000
    fi
fi
