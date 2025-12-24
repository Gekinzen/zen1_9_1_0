#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "wlogout-wallpaper-toggle"

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

# Main menu function
show_menu() {
    # Re-read state in case it changed
    source "$CONFIG_FILE"
    
    # Format status
    if [ "$ENABLE_WALLPAPER" = "true" ]; then
        STATUS="🟢 Enabled"
        NEW_STATE="false"
        ACTION="🔴 Disable"
    else
        STATUS="🔴 Disabled"
        NEW_STATE="true"
        ACTION="🟢 Enable"
    fi
    
    # Show menu
    CHOICE=$(echo -e "Current Status: ${STATUS}\n━━━━━━━━━━━━━━━━━━━━━━━━━━━\n${ACTION} Wallpaper Background\n📋 Wlogout Config\n◀️ Back" | \
        rofi -dmenu -i \
        -p "Wlogout Wallpaper" \
        -theme ~/.config/rofi/wlogout-menu.rasi)
    
    case "$CHOICE" in
        *"Enable"*|*"Disable"*)
            # Toggle the state
            sed -i "s/ENABLE_WALLPAPER=.*/ENABLE_WALLPAPER=$NEW_STATE/" "$CONFIG_FILE"
            
            # Send notification
            if [ "$NEW_STATE" = "true" ]; then
                notify-send "Wlogout" "Wallpaper background enabled ✓" -i preferences-desktop-wallpaper
            else
                notify-send "Wlogout" "Wallpaper background disabled ✗" -i preferences-desktop-wallpaper
            fi
            
            # Show menu again to see updated state
            show_menu
            ;;
        "📋 Wlogout Config")
            # Open config in editor
            kitty --class floating -e nano "$CONFIG_FILE"
            show_menu
            ;;
        "◀️ Back"|"")
            exit 0
            ;;
    esac
}

# Start menu
show_menu