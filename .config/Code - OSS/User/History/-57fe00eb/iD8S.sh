#!/bin/bash

# Single instance check
LOCK_FILE="/tmp/system-settings.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Settings already open - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "wofi.*System Settings"
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Function to show main menu
show_main_menu() {
    CHOICE=$(echo -e "🎨 System Decoration\n⚙️ Wlogout Settings\n⌨️ Keybindings\n🔄 Reload Pywal Colors\n❌ Close" | \
        wofi --dmenu \
        --prompt "System Settings" \
        --width 400 \
        --height 350 \
        --style ~/.config/wofi/menu-style.css)
    
    case "$CHOICE" in
        "🎨 System Decoration")
            show_decoration_menu
            ;;
        "⚙️ Wlogout Settings")
            ~/.config/wlogout/toggle-wallpaper.sh
            show_main_menu  # Return to main menu
            ;;
        "⌨️ Keybindings")
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
            show_main_menu  # Return to main menu
            ;;
        "🔄 Reload Pywal Colors")
            wal -R
            notify-send "Pywal" "Colors reloaded from current wallpaper" -i preferences-desktop-theme
            show_main_menu  # Return to main menu
            ;;
        "❌ Close"|"")
            rm -f "$LOCK_FILE"
            exit 0
            ;;
    esac
}

# Function to show decoration submenu
show_decoration_menu() {
    CHOICE=$(echo -e "🪟 Window Opacity\n🎨 Theme Settings\n◀️ Back" | \
        wofi --dmenu \
        --prompt "System Decoration" \
        --width 400 \
        --height 250 \
        --style ~/.config/wofi/menu-style.css)
    
    case "$CHOICE" in
        "🪟 Window Opacity")
            show_opacity_settings
            ;;
        "🎨 Theme Settings")
            notify-send "Theme Settings" "Coming soon!" -i preferences-desktop-theme
            show_decoration_menu  # Stay in this menu
            ;;
        "◀️ Back"|"")
            show_main_menu  # Go back to main menu
            ;;
    esac
}

# Function to show opacity settings
show_opacity_settings() {
    CHOICE=$(echo -e "🔆 Active Opacity\n🔅 Inactive Opacity\n◀️ Back" | \
        wofi --dmenu \
        --prompt "Window Opacity" \
        --width 400 \
        --height 250 \
        --style ~/.config/wofi/menu-style.css)
    
    case "$CHOICE" in
        "🔆 Active Opacity")
            set_opacity "active"
            show_opacity_settings  # Stay in this menu
            ;;
        "🔅 Inactive Opacity")
            set_opacity "inactive"
            show_opacity_settings  # Stay in this menu
            ;;
        "◀️ Back"|"")
            show_decoration_menu  # Go back to decoration menu
            ;;
    esac
}

# Function to set opacity
set_opacity() {
    TYPE=$1
    CURRENT=$(grep "${TYPE}_opacity" ~/.config/hypr/hyprland.conf | awk '{print $3}')
    
    INPUT=$(echo "" | wofi --dmenu \
        --prompt "Enter ${TYPE} opacity (0.1-1.0, current: ${CURRENT})" \
        --width 400 \
        --height 150 \
        --style ~/.config/wofi/menu-style.css)
    
    if [[ "$INPUT" =~ ^[0-9]*\.?[0-9]+$ ]]; then
        if (( $(echo "$INPUT >= 0.1" | bc -l) )) && (( $(echo "$INPUT <= 1.0" | bc -l) )); then
            sed -i "s/${TYPE}_opacity = .*/${TYPE}_opacity = ${INPUT}/" ~/.config/hypr/hyprland.conf
            hyprctl reload
            notify-send "Opacity Changed" "${TYPE^} opacity set to ${INPUT}" -i preferences-desktop
        else
            notify-send "Invalid Input" "Opacity must be between 0.1 and 1.0" -i dialog-error
        fi
    fi
}

# Start with main menu
show_main_menu

rm -f "$LOCK_FILE"