#!/bin/bash
# ~/.config/hypr/scripts/fullscreen-listener.sh

# Watch for fullscreen events
socat -u UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock - | \
while read -r line; do
    if [[ $line == *"fullscreen 1"* ]]; then
        # Hide dock and waybar when fullscreen
        pkill -SIGRTMIN+3 nwg-dock-hyprland
        pkill -SIGUSR1 waybar
    elif [[ $line == *"fullscreen 0"* ]]; then
        # Show dock and waybar again
        pkill -SIGRTMIN+2 nwg-dock-hyprland
        pkill -SIGUSR1 waybar
    fi
done


