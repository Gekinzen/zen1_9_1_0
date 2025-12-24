#!/bin/bash

# Get all workspaces
WORKSPACES=$(hyprctl workspaces -j | jq -r '.[].id' | sort -n)

for ws in $WORKSPACES; do
    # Count windows in workspace
    WINDOWS=$(hyprctl workspaces -j | jq -r ".[] | select(.id == $ws) | .windows")
    
    # If empty and not workspace 1, remove it
    if [ "$WINDOWS" -eq 0 ] && [ "$ws" -ne 1 ]; then
        hyprctl dispatch workspace $ws
        hyprctl dispatch workspace 1
    fi
done

notify-send "Workspaces" "Empty workspaces cleaned" -i preferences-desktop
