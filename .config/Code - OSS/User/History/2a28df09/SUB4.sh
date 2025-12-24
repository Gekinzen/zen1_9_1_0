#!/usr/bin/env bash
#
# Clean and fixed launcher for nwg-dock-hyprland

CONFIG_DIR="$HOME/.config/nwg-dock-hyprland"
CONFIG_FILE="$CONFIG_DIR/config"
STYLE_FILE="$CONFIG_DIR/style.css"

# Kill any existing dock process
pkill -f nwg-dock-hyprland 2>/dev/null

sleep 0.4

# Ensure config files are readable
chmod 755 "$CONFIG_DIR" 2>/dev/null
chmod 644 "$CONFIG_FILE" "$STYLE_FILE" 2>/dev/null

# Apply valid layer rules (Hyprland-safe)
hyprctl keyword layerrule "noanim, nwg-dock-hyprland"
hyprctl keyword layerrule "blur, nwg-dock-hyprland"
hyprctl keyword layerrule "ignorealpha 0.5, nwg-dock-hyprland"

sleep 1

# Run the dock without passing style manually (use config)
nwg-dock-hyprland -c "$CONFIG_FILE" &

sleep 0.5

# Restore focus so it doesn't force fullscreen
active_window=$(hyprctl activewindow -j | jq -r '.address')
[ -n "$active_window" ] && hyprctl dispatch focuswindow "$active_window"
