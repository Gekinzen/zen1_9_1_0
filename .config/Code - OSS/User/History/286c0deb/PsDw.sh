#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "opacity-settings"

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Get current values
CURRENT_ACTIVE=$(grep "active_opacity" "$HYPR_CONFIG" | grep -oP '\d+\.\d+' | head -1)
CURRENT_INACTIVE=$(grep "inactive_opacity" "$HYPR_CONFIG" | grep -oP '\d+\.\d+' | head -1)

# Menu
CHOICE=$(echo -e "🔆 Active Opacity: $CURRENT_ACTIVE\n🔅 Inactive Opacity: $CURRENT_INACTIVE\n⬅️ Back" | \
    wofi --dmenu --prompt "Opacity Settings" --width 400 --height 250 --style ~/.config/wofi/menu-style.css)

case "$CHOICE" in
    "🔆 Active Opacity:"*)
        NEW_VALUE=$(echo "" | wofi --dmenu --prompt "Enter Active Opacity (0.1-1.0)" --width 400 --style ~/.config/wofi/menu-style.css)
        
        if [[ "$NEW_VALUE" =~ ^0\.[0-9]+$|^1\.0$ ]]; then
            sed -i "s/active_opacity = .*/active_opacity = $NEW_VALUE/" "$HYPR_CONFIG"
            hyprctl keyword decoration:active_opacity "$NEW_VALUE"
            notify-send "Opacity Settings" "Active opacity set to $NEW_VALUE" -i preferences-desktop
        else
            notify-send "Error" "Invalid value! Use 0.1 to 1.0" -u critical
        fi
        ;;
        
    "🔅 Inactive Opacity:"*)
        NEW_VALUE=$(echo "" | wofi --dmenu --prompt "Enter Inactive Opacity (0.1-1.0)" --width 400 --style ~/.config/wofi/menu-style.css)
        
        if [[ "$NEW_VALUE" =~ ^0\.[0-9]+$|^1\.0$ ]]; then
            sed -i "s/inactive_opacity = .*/inactive_opacity = $NEW_VALUE/" "$HYPR_CONFIG"
            hyprctl keyword decoration:inactive_opacity "$NEW_VALUE"
            notify-send "Opacity Settings" "Inactive opacity set to $NEW_VALUE" -i preferences-desktop
        else
            notify-send "Error" "Invalid value! Use 0.1 to 1.0" -u critical
        fi
        ;;
esac