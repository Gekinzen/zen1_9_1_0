#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "waybar-refresh"

# Check if waybar is running
if pgrep -x "waybar" > /dev/null; then
    # If running, kill and restart
    pkill -x "waybar"
    sleep 0.3
    waybar &
    notify-send "Waybar" "Refreshed" -i preferences-desktop
else
    # If not running, start waybar
    waybar &
    notify-send "Waybar" "Started" -i preferences-desktop
fi