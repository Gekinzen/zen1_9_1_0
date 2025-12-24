#!/bin/bash
CONFIG="/home/paul/.config/nwg-dock-hyprland/config"

pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null
sleep 0.3

nwg-dock-hyprland -c "$CONFIG" > /tmp/nwg-dock.log 2>&1 &

echo "Dock launched. Check /tmp/nwg-dock.log"
