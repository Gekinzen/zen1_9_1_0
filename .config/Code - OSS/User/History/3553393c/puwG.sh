#!/bin/bash

# Get current layout
layout=$(hyprctl getoption general:layout | grep -oE '(dwindle|master|float)' | head -n1)

# More thorough kill process
pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null

# Wait and verify processes are actually dead
for i in {1..10}; do
    if ! pgrep -f "nwg-dock" > /dev/null; then
        break
    fi
    sleep 0.1
done

# Additional cleanup - kill by exact process name
killall -9 nwg-dock-hyprland 2>/dev/null
sleep 0.5

# Launch dock based on layout
if [[ "$layout" == "float" ]]; then
    ~/.config/hypr/scripts/dock-manager.sh float
else
    ~/.config/hypr/scripts/dock-manager.sh tiling
fi