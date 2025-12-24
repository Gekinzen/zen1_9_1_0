#!/bin/bash

# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "system-settings"

# Main menu
CHOICE=$(echo -e "🎨 System Decoration\n⚙️ Wlogout Settings\n⌨️ Keybindings\n❌ Close" | \
    wofi --dmenu --prompt "System Settings" --width 400 --height 300 --style ~/.config/wofi/menu-style.css)

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
esac