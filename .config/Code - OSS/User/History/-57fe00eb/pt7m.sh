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

# Source pywal colors
source ~/.cache/wal/colors.sh

# Main menu with pywal colors
CHOICE=$(echo -e "🎨 System Decoration\n⚙️ Wlogout Settings\n⌨️ Keybindings\n🔄 Reload Pywal Colors\n❌ Close" | \
    wofi --dmenu \
    --prompt "System Settings" \
    --width 400 \
    --height 350 \
    --style ~/.config/wofi/menu-style.css)

case "$CHOICE" in
    "🎨 System Decoration")
        ~/.config/hypr/scripts/opacity-settings.sh
        ;;
    "⚙️ Wlogout Settings")
        ~/.config/wlogout/toggle-wallpaper.sh
        ;;
    "⌨️ Keybindings")
        ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
        ;;
    "🔄 Reload Pywal Colors")
        wal -R
        notify-send "Pywal" "Colors reloaded from current wallpaper" -i preferences-desktop-theme
        ;;
esac

rm -f "$LOCK_FILE"