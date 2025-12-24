#!/bin/bash

CONFIG="/home/paul/.config/nwg-dock-hyprland/config"

# Kill any existing dock
pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null
sleep 0.3

# Launch dock (always visible, no -d)
nwg-dock-hyprland -c "$CONFIG" > /tmp/nwg-dock.log 2>&1 &

echo "Dock launched. Check /tmp/nwg-dock.log"
