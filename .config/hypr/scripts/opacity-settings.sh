#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "opacity-settings"

HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Get current values
CURRENT_ACTIVE=$(grep "active_opacity" "$HYPR_CONFIG" | grep -oP '\d+\.\d+' | head -1)
CURRENT_INACTIVE=$(grep "inactive_opacity" "$HYPR_CONFIG" | grep -oP '\d+\.\d+' | head -1)

# Main menu
CHOICE=$(echo -e "🔆 Active Opacity (Current: $CURRENT_ACTIVE)\n🔅 Inactive Opacity (Current: $CURRENT_INACTIVE)\n⬅️ Back" | \
    rofi -dmenu -i \
    -p "Opacity Settings" \
    -theme ~/.config/rofi/opacity-menu.rasi)

case "$CHOICE" in
    "🔆 Active Opacity"*)
        # Show preset values + custom option
        NEW_VALUE=$(echo -e "1.0 (Solid)\n0.95\n0.90\n0.85\n0.80\n0.75\n0.70\n➕ Custom Value" | \
            rofi -dmenu -i \
            -p "Select Active Opacity" \
            -theme ~/.config/rofi/opacity-selector.rasi)
        
        # If custom, prompt for input
        if [[ "$NEW_VALUE" == "➕ Custom Value" ]]; then
            NEW_VALUE=$(rofi -dmenu -i \
                -p "Enter Opacity (0.1-1.0)" \
                -theme ~/.config/rofi/opacity-input.rasi)
        else
            # Extract just the number
            NEW_VALUE=$(echo "$NEW_VALUE" | grep -oP '\d+\.\d+')
        fi
        
        # Validate and apply
        if [[ "$NEW_VALUE" =~ ^0\.[1-9][0-9]*$|^1\.0$ ]]; then
            sed -i "s/active_opacity = .*/active_opacity = $NEW_VALUE/" "$HYPR_CONFIG"
            hyprctl keyword decoration:active_opacity "$NEW_VALUE"
            notify-send "Opacity Settings" "Active opacity: $NEW_VALUE" -i preferences-desktop
        elif [[ -n "$NEW_VALUE" ]]; then
            notify-send "Error" "Invalid value! Use 0.1 to 1.0" -u critical
        fi
        ;;
        
    "🔅 Inactive Opacity"*)
        # Show preset values + custom option
        NEW_VALUE=$(echo -e "0.95\n0.90\n0.85\n0.80\n0.75\n0.70\n0.65\n➕ Custom Value" | \
            rofi -dmenu -i \
            -p "Select Inactive Opacity" \
            -theme ~/.config/rofi/opacity-selector.rasi)
        
        # If custom, prompt for input
        if [[ "$NEW_VALUE" == "➕ Custom Value" ]]; then
            NEW_VALUE=$(rofi -dmenu -i \
                -p "Enter Opacity (0.1-1.0)" \
                -theme ~/.config/rofi/opacity-input.rasi)
        else
            # Extract just the number
            NEW_VALUE=$(echo "$NEW_VALUE" | grep -oP '\d+\.\d+')
        fi
        
        # Validate and apply
        if [[ "$NEW_VALUE" =~ ^0\.[1-9][0-9]*$|^1\.0$ ]]; then
            sed -i "s/inactive_opacity = .*/inactive_opacity = $NEW_VALUE/" "$HYPR_CONFIG"
            hyprctl keyword decoration:inactive_opacity "$NEW_VALUE"
            notify-send "Opacity Settings" "Inactive opacity: $NEW_VALUE" -i preferences-desktop
        elif [[ -n "$NEW_VALUE" ]]; then
            notify-send "Error" "Invalid value! Use 0.1 to 1.0" -u critical
        fi
        ;;
esac