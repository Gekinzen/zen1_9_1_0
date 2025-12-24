#!/bin/bash

# Get PRIMARY monitor (leftmost by X position, NOT focused monitor)
get_primary_monitor() {
    # Always use leftmost monitor (lowest x position) as primary
    local monitor=$(hyprctl monitors -j | jq -r 'sort_by(.x) | .[0].name')
    
    # Fallback if jq fails
    if [[ -z "$monitor" ]]; then
        monitor=$(hyprctl monitors -j | jq -r '.[0].name')
    fi
    
    echo "$monitor"
}

PRIMARY_MONITOR=$(get_primary_monitor)
echo "Primary monitor (by position): $PRIMARY_MONITOR" | tee -a /tmp/dock-launcher.log

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

# Launch dock with PRIMARY monitor (not focused)
if [[ "$layout" == "float" ]]; then
    ~/.config/hypr/scripts/dock-manager.sh float "$PRIMARY_MONITOR"
else
    ~/.config/hypr/scripts/dock-manager.sh tiling "$PRIMARY_MONITOR"
fi