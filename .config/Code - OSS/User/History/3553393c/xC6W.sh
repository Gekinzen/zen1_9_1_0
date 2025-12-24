#!/bin/bash

# Kill any existing instances
pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null
sleep 0.3

# Launch dock in background
nwg-dock-hyprland -d > /tmp/nwg-dock.log 2>&1 &

echo "Dock launched. Check /tmp/nwg-dock.log for errors."