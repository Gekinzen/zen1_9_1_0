#!/bin/bash

# Get primary monitor
PRIMARY_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name' | head -n1)

# Fallback if no focused monitor
if [[ -z "$PRIMARY_MONITOR" ]]; then
    PRIMARY_MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
fi

echo "Using monitor: $PRIMARY_MONITOR"

# Get current layout
layout=$(hyprctl getoption general:layout | grep -oE '(dwindle|master|float)' | head -n1)

# Kill existing instances thoroughly
pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null

for i in {1..10}; do
    if ! pgrep -f "nwg-dock" > /dev/null; then
        break
    fi
    sleep 0.1
done

killall -9 nwg-dock-hyprland 2>/dev/null
sleep 0.5

# Launch dock with monitor specified
if [[ "$layout" == "float" ]]; then
    ~/.config/hypr/scripts/dock-manager.sh float "$PRIMARY_MONITOR"
else
    ~/.config/hypr/scripts/dock-manager.sh tiling "$PRIMARY_MONITOR"
fi