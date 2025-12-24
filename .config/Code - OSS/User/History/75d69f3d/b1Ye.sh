#!/bin/bash

# Kill existing instances
pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null
sleep 0.3

# Launch dock
nwg-dock-hyprland -c /home/paul/.config/nwg-dock-hyprland/config -d > /tmp/nwg-dock.log 2>&1 &

echo "Dock launched. Check /tmp/nwg-dock.log for errors."
