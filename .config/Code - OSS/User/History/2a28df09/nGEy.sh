#!/usr/bin/env bash
#
# Launch script for nwg-dock-hyprland with proper layer handling

# Kill existing instance if any
pkill -f nwg-dock-hyprland

# Small delay to ensure cleanup
sleep 0.3

# Set paths
CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
CONFIG_FILE="$CONFIG_DIR/config"
STYLE_FILE="$CONFIG_DIR/style.css"

# Ensure permissions are correct (no need for sudo)
chmod +x "$CONFIG_FILE" 2>/dev/null
chmod 644 "$STYLE_FILE" 2>/dev/null

# Apply layer rules dynamically (prevents fullscreen overlap)
hyprctl keyword layerrule "noanim, nwg-dock-hyprland"
hyprctl keyword layerrule "blur, nwg-dock-hyprland"
hyprctl keyword layerrule "ignorealpha, nwg-dock-hyprland"
hyprctl keyword layerrule "nofocus, nwg-dock-hyprland"
hyprctl keyword layerrule "keepbelow, nwg-dock-hyprland"

# Launch the dock
nwg-dock-hyprland -c "$CONFIG_FILE" -s "$STYLE_FILE" &

# Optional delay to ensure the dock is up before focus restore
sleep 0.5

# Restore focus to the active window
hyprctl dispatch focuswindow "$(hyprctl activewindow -j | jq -r '.address')" 2>/dev/null
