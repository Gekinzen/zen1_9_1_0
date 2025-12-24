#!/bin/bash

# Kill wofi if still running
pkill -f wofi 2>/dev/null

# Refresh waybar
pkill -SIGUSR2 waybar 2>/dev/null
sleep 0.2

# Reset focus to any window
active_window=$(hyprctl activewindow -j | jq -r '.address')
if [ "$active_window" != "null" ]; then
    hyprctl dispatch focuswindow address:$active_window
else
    # If no active window, focus the first available
    first_window=$(hyprctl clients -j | jq -r '.[0].address')
    hyprctl dispatch focuswindow address:$first_window
fi
