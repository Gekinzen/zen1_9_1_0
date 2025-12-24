#!/bin/bash

# Get waybar and dock PIDs once at start
get_waybar_windows() {
    hyprctl layers -j | jq -r '.[][] | select(.namespace == "waybar") | .address'
}

get_dock_windows() {
    hyprctl layers -j | jq -r '.[][] | select(.namespace == "nwg-dock") | .address'
}

hide_layers() {
    # Hide waybar
    for addr in $(get_waybar_windows); do
        hyprctl setprop address:$addr alphaoverride 0 lock
    done
    
    # Hide dock
    for addr in $(get_dock_windows); do
        hyprctl setprop address:$addr alphaoverride 0 lock
    done
}

show_layers() {
    # Show waybar
    for addr in $(get_waybar_windows); do
        hyprctl setprop address:$addr alphaoverride -1
    done
    
    # Show dock
    for addr in $(get_dock_windows); do
        hyprctl setprop address:$addr alphaoverride -1
    done
}

previous_state=""

while true; do
    window_info=$(hyprctl -j activewindow)
    fullscreen=$(echo "$window_info" | jq -r '.fullscreen')
    
    # fullscreen values:
    # 0 = true fullscreen (covers everything)
    # 1 = maximize fullscreen (respects reserved space)
    # false = not fullscreen
    
    if [[ "$fullscreen" == "0" ]]; then
        if [[ "$previous_state" != "hidden" ]]; then
            hide_layers
            previous_state="hidden"
        fi
    else
        if [[ "$previous_state" != "shown" ]]; then
            show_layers
            previous_state="shown"
        fi
    fi
    
    sleep 0.3
done