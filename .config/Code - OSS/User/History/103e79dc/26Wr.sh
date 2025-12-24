#!/bin/bash

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/wlogout-toggle.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Wlogout settings already open - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "wofi.*Wlogout"
        exit 0
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

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
    wofi --dmenu --prompt "Wlogout Settings" --width 400 --height 250)

if [ "$CHOICE" = "🔄 Toggle Wallpaper" ]; then
    sed -i "s/ENABLE_WALLPAPER=.*/ENABLE_WALLPAPER=$NEW_STATE/" "$CONFIG_FILE"
    
    if command -v notify-send &> /dev/null; then
        if [ "$NEW_STATE" = "true" ]; then
            notify-send "Wlogout" "Wallpaper background enabled" -i preferences-desktop-wallpaper
        else
            notify-send "Wlogout" "Wallpaper background disabled" -i preferences-desktop-wallpaper
        fi
    fi
    
    echo "Wallpaper background toggled to: $NEW_STATE"
fi

rm -f "$LOCK_FILE"