#!/bin/bash

# Single instance check
LOCK_FILE="/tmp/system-settings.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Settings already open - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "rofi.*System Settings"
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
        rofi -dmenu -i \
        -p "System Settings" \
        -theme ~/.config/rofi/system-menu.rasi)
    
    case "$CHOICE" in
        "🎨 System Decoration")
            show_decoration_menu
            ;;
        "⚙️ Wlogout Settings")
            ~/.config/wlogout/toggle-wallpaper.sh
            show_main_menu
            ;;
        "⌨️ Keybindings")
            ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
            show_main_menu
            ;;
        "🔄 Reload Pywal Colors")
            wal -R
            notify-send "Pywal" "Colors reloaded" -i preferences-desktop-theme
            show_main_menu
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
        rofi -dmenu -i \
        -p "System Decoration" \
        -theme ~/.config/rofi/system-submenu.rasi)
    
    case "$CHOICE" in
        "🪟 Window Opacity")
            ~/.config/hypr/scripts/opacity-settings.sh
            show_decoration_menu
            ;;
        "🎨 Theme Settings")
            notify-send "Theme Settings" "Coming soon!" -i preferences-desktop-theme
            show_decoration_menu
            ;;
        "◀️ Back"|"")
            show_main_menu
            ;;
    esac
}

# Start with main menu
show_main_menu
rm -f "$LOCK_FILE"