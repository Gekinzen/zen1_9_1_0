#!/bin/bash

CONFIG_FILE="$HOME/.config/wlogout/config.conf"

# Create config if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    mkdir -p "$(dirname "$CONFIG_FILE")"
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

# Toggle
if [ "$ENABLE_WALLPAPER" = "true" ]; then
    NEW_STATE="false"
    notify-send "Wlogout" "Wallpaper background disabled 🔴" -i preferences-desktop-wallpaper
else
    NEW_STATE="true"
    notify-send "Wlogout" "Wallpaper background enabled 🟢" -i preferences-desktop-wallpaper
fi

# Apply
sed -i "s/ENABLE_WALLPAPER=.*/ENABLE_WALLPAPER=$NEW_STATE/" "$CONFIG_FILE"
