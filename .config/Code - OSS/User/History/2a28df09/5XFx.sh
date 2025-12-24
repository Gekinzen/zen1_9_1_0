#!/usr/bin/env bash
#
# Clean launch script for nwg-dock-hyprland
# Fixes: style path, permission denied, fullscreen overlap

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
CONFIG_FILE="$CONFIG_DIR/config"
STYLE_FILE="$CONFIG_DIR/style.css"

# Kill existing instances
pkill -f nwg-dock-hyprland 2>/dev/null

# Wait a bit for cleanup
sleep 0.4

# Ensure permissions
chmod 755 "$CONFIG_FILE" 2>/dev/null
chmod 644 "$STYLE_FILE" 2>/dev/null

# Apply valid layer rules (Hyprland 0.40+ safe)
hyprctl keyword layerrule "noanim, nwg-dock-hyprland"
hyprctl keyword layerrule "blur, nwg-dock-hyprland"
hyprctl keyword layerrule "ignorealpha, nwg-dock-hyprland"

# Delay to ensure Hyprland windows are initialized before dock spawns
sleep 1

# Launch dock cleanly with correct paths
nwg-dock-hyprland -c "$CONFIG_FILE" -s "$STYLE_FILE" &

# Give the dock a moment to spawn
sleep 0.5

# Restore focus to current window (so it doesn't start fullscreen)
active_window=$(hyprctl activewindow -j | jq -r '.address')
[ -n "$active_window" ] && hyprctl dispatch focuswindow "$active_window"
