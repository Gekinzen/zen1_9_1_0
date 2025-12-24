#!/bin/bash

# Kill any existing system settings notification
swaync-client -C

# Create notification with action buttons
ACTION=$(notify-send -u normal -t 0 \
    --app-name="SystemSettings" \
    "󰒓 System Settings" \
    "Select a category to configure" \
    --action="appearance=󰏘 Appearance" \
    --action="system=󰒓 System" \
    --action="desktop=󰍹 Desktop" \
    --action="keybindings=󰌌 Keybindings")

case "$ACTION" in
    appearance)
        ~/.config/hypr/scripts/system-settings.sh
        ;;
    system)
        ~/.config/hypr/scripts/system-settings.sh
        ;;
    desktop)
        ~/.config/hypr/scripts/system-settings.sh
        ;;
    keybindings)
        ~/.config/hypr/scripts/keybinding-viewer-interactive.sh
        ;;
esac