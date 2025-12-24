#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "wlogout-wallpaper-toggle"

CONFIG_FILE="$HOME/.config/wlogout/config.conf"

# Create config if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
# Wlogout Configuration
MGN=10
HVR=20
BUTTON_RAD=20
ACTIVE_RAD=80
FNT_SIZE=18
ENABLE_WALLPAPER=true
EOF
fi

# Read current state
source "$CONFIG_FILE"

# Determine current state with checkmark
if [ "$ENABLE_WALLPAPER" = "true" ]; then
    CURRENT_STATE="✓ Wallpaper Background Enabled"
    NEW_STATE="false"
else
    CURRENT_STATE="✗ Wallpaper Background Disabled"
    NEW_STATE="true"
fi

# Show wofi menu
CHOICE=$(echo -e "$CURRENT_STATE\n---\n🔄 Toggle Wallpaper\n⬅️ Back" | \
    wofi --dmenu --prompt "Wlogout Settings" --width 400 --height 250 --style ~/.config/wofi/menu-style.css)

if [ "$CHOICE" = "🔄 Toggle Wallpaper" ]; then
    sed -i "s/ENABLE_WALLPAPER=.*/ENABLE_WALLPAPER=$NEW_STATE/" "$CONFIG_FILE"
    
    if command -v notify-send &> /dev/null; then
        if [ "$NEW_STATE" = "true" ]; then
            notify-send "Wlogout" "Wallpaper background enabled" -i preferences-desktop-wallpaper
        else
            notify-send "Wlogout" "Wallpaper background disabled" -i preferences-desktop-wallpaper
        fi
    fi
fi