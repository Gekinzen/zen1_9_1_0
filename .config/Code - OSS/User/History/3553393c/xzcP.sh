#!/bin/bash

# Single instance check
if pgrep -x "nwg-dock-hypr" > /dev/null; then
    pkill -x nwg-dock-hypr
    exit 0
fi

# Launch dock
nwg-dock-hyprland -c ~/.config/nwg-dock-hyprland/config -d &