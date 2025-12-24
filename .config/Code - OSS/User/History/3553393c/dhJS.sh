#!/bin/bash

# Check if dock is already running
if pgrep -x "nwg-dock-hypr" > /dev/null; then
    echo "Dock already running"
    exit 0
fi

# Launch dock
nwg-dock-hyprland -d &