#!/bin/bash

echo "Updating hyprbars glass effect from pywal..."

# Check if pywal colors exist
if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    notify-send "󰚰 Hyprbars Glass" "Pywal colors not found" -u critical
    exit 1
fi

# Source colors
source ~/.cache/wal/colors.sh

# Remove # from hex colors
BG="${background#\#}"
FG="${foreground#\#}"
BTN_RED="${color9#\#}"
BTN_YELLOW="${color11#\#}"
BTN_GREEN="${color10#\#}"

# Calculate transparency levels
# cc = 80% opacity (glass effect)
# dd = 87% opacity (slightly more visible)
# ee = 93% opacity (subtle glass)

GLASS_OPACITY="cc"  # 80% for nice glass effect

echo "Applying glass effect:"
echo "  Bar: #${BG}${GLASS_OPACITY} (80% opacity)"
echo "  Text: #$FG"
echo "  Buttons: Dynamic pywal colors"

CONFIG="$HOME/.config/hypr/hyprland.conf"

# Backup
cp "$CONFIG" "${CONFIG}.bak"

# Update bar colors with glass transparency
sed -i "/hyprbars {/,/^    }/{ 
    s/bar_color = rgba([^)]*)/bar_color = rgba(${BG}${GLASS_OPACITY})/
    s/col\.text = rgb([^)]*)/col.text = rgb($FG)/
}" "$CONFIG"

# Update button colors (option: keep macOS colors or use pywal)
# Uncomment to use pywal colors for buttons:
# awk -v red="$BTN_RED" -v yellow="$BTN_YELLOW" -v green="$BTN_GREEN" '
# /hyprbars-button.*killactive/ {
#     sub(/rgb\([^)]*\)/, "rgb(" red ")")
# }
# /hyprbars-button.*minimize/ {
#     sub(/rgb\([^)]*\)/, "rgb(" yellow ")")
# }
# /hyprbars-button.*fullscreen/ {
#     sub(/rgb\([^)]*\)/, "rgb(" green ")")
# }
# {print}
# ' "$CONFIG" > /tmp/hypr_temp && mv /tmp/hypr_temp "$CONFIG"

echo "✓ Glass effect applied"

# Reload Hyprland
hyprctl reload

notify-send "󰚰 Hyprbars Glass" "Premium glass effect applied" -t 2000 -i preferences-desktop-theme
