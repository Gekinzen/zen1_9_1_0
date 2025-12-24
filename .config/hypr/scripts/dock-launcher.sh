#!/bin/bash
# dock-launcher.sh - with explicit primary monitor

# OPTION 1: Hardcode your primary monitor
PRIMARY_MONITOR="DP-2"  # Change this to your actual primary

# OPTION 2: Detect by resolution (get highest res monitor)
# PRIMARY_MONITOR=$(hyprctl monitors -j | jq -r 'sort_by(.width * .height) | reverse | .[0].name')

# OPTION 3: Detect by refresh rate (get highest refresh)
# PRIMARY_MONITOR=$(hyprctl monitors -j | jq -r 'sort_by(.refreshRate) | reverse | .[0].name')

echo "Primary monitor: $PRIMARY_MONITOR" | tee -a /tmp/dock-launcher.log

# Get current layout
layout=$(hyprctl getoption general:layout | grep -oE '(dwindle|master|float)' | head -n1)

# Kill existing instances
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

# Launch dock
if [[ "$layout" == "float" ]]; then
    ~/.config/hypr/scripts/dock-manager.sh float "$PRIMARY_MONITOR"
else
    ~/.config/hypr/scripts/dock-manager.sh tiling "$PRIMARY_MONITOR"
fi