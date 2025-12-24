#!/bin/bash

# Paths
DOCK_CONFIG="/home/paul/.config/nwg-dock-hyprland/config"          # always-visible config
DOCK_CONFIG_AUTOHIDE="/home/paul/.config/nwg-dock-hyprland/config-autohide"  # optional

# Kill any existing instances
pkill -9 nwg-dock-hypr 2>/dev/null
pkill -9 nwg-dock-hyprland 2>/dev/null
sleep 0.3

# Force always-visible dock
nwg-dock-hyprland -c "$DOCK_CONFIG" -d > /tmp/nwg-dock.log 2>&1 &

echo "Dock launched (always visible). Check /tmp/nwg-dock.log for errors."
