#!/bin/bash

echo "Updating hyprbars colors from pywal..."

# Check if pywal colors exist
if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    exit 1
fi

# Source colors
source ~/.cache/wal/colors.sh

# Remove # from hex colors
BG="${background#\#}"
FG="${foreground#\#}"
C9="${color9#\#}"
C10="${color10#\#}"
C11="${color11#\#}"

echo "Colors:"
echo "  Background: #$BG"
echo "  Foreground: #$FG"

# Find the hyprbars section and update it
CONFIG="$HOME/.config/hypr/hyprland.conf"
TEMP_FILE="/tmp/hyprland_conf_temp"

# Backup
cp "$CONFIG" "${CONFIG}.bak"

# Update colors using sed
sed -i "/plugin {/,/^}/{ 
    s/bar_color = rgb([^)]*)/bar_color = rgb($BG)/
    s/col\.text = rgb([^)]*)/col.text = rgb($FG)/
}" "$CONFIG"

echo "Updated hyprland.conf"

# Reload Hyprland
hyprctl reload

notify-send "󰚰 Hyprbars Colors" "Updated from pywal" -t 2000 -i preferences-desktop-theme
