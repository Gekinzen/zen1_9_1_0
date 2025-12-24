#!/bin/bash

DOCK_CONFIG="/home/paul/.config/nwg-dock-hyprland/config"

# Kill any existing dock instances
pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null
sleep 0.3

# Force ALWAYS VISIBLE by explicitly passing --autohide=false
nwg-dock-hyprland -c "$DOCK_CONFIG" -d --autohide=false > /tmp/nwg-dock.log 2>&1 &

echo "Dock launched (always visible). Check /tmp/nwg-dock.log"
