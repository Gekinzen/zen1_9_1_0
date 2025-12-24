#!/bin/bash

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
    NEW_LABEL="Wallpaper Background Disabled"
else
    CURRENT_STATE="✗ Wallpaper Background Disabled"
    NEW_STATE="true"
    NEW_LABEL="Wallpaper Background Enabled"
fi

# Show wofi menu
CHOICE=$(echo -e "$CURRENT_STATE\n---\nToggle Wallpaper" | wofi --dmenu --prompt "Wlogout Settings")

if [ "$CHOICE" = "Toggle Wallpaper" ]; then
    # Toggle the setting
    sed -i "s/ENABLE_WALLPAPER=.*/ENABLE_WALLPAPER=$NEW_STATE/" "$CONFIG_FILE"
    
    # Show notification
    if command -v notify-send &> /dev/null; then
        if [ "$NEW_STATE" = "true" ]; then
            notify-send "Wlogout" "Wallpaper background enabled" -i preferences-desktop-wallpaper
        else
            notify-send "Wlogout" "Wallpaper background disabled" -i preferences-desktop-wallpaper
        fi
    fi
    
    echo "Wallpaper background toggled to: $NEW_STATE"
fi
