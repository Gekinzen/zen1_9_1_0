#!/bin/bash

# Load config
source ~/.config/hypr/workspace-monitors.conf

# Get workspace info
WORKSPACES=$(hyprctl workspaces -j)

# Build menu
MENU=""

# Primary monitor workspaces
MENU+="=== PRIMARY MONITOR ($PRIMARY_MONITOR) ===\n"
for i in {1..8}; do
    WINDOWS=$(echo "$WORKSPACES" | jq -r ".[] | select(.id==$i) | .windows")
    if [ "$WINDOWS" = "null" ] || [ -z "$WINDOWS" ]; then
        WINDOWS=0
    fi
    MENU+="󰍹 Workspace $i ($WINDOWS windows)\n"
done

# Secondary monitor workspaces
if [ -n "$SECONDARY_MONITOR" ]; then
    MENU+="\n=== SECONDARY MONITOR ($SECONDARY_MONITOR) ===\n"
    for i in {11..14}; do
        DISPLAY_NUM=$((i - 10))
        WINDOWS=$(echo "$WORKSPACES" | jq -r ".[] | select(.id==$i) | .windows")
        if [ "$WINDOWS" = "null" ] || [ -z "$WINDOWS" ]; then
            WINDOWS=0
        fi
        MENU+="󰍹 Workspace $DISPLAY_NUM ($WINDOWS windows)\n"
    done
fi

# Show in rofi
CHOICE=$(echo -e "$MENU" | rofi -dmenu -i -p "󰍹 Workspaces" -theme ~/.config/rofi/power-menu.rasi)

# Parse choice and switch
if [[ "$CHOICE" =~ Workspace\ ([0-9]+) ]]; then
    WS="${BASH_REMATCH[1]}"
    
    # Determine actual workspace number
    CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')
    
    if [ "$CURRENT_MONITOR" = "$SECONDARY_MONITOR" ] && [ "$WS" -le 4 ]; then
        # Convert to secondary workspace number
        ACTUAL_WS=$((WS + 10))
        hyprctl dispatch workspace "$ACTUAL_WS"
    else
        hyprctl dispatch workspace "$WS"
    fi
fi
