#!/bin/bash

# Show system settings as swaync notification
notify-send -u normal -t 0 "󰒓 System Settings" \
"Select an option:

󰏘 Appearance
󰒓 System
󰍹 Desktop
󰌌 Keybindings

Click to configure" \
-i preferences-system \
--action="appearance=󰏘 Appearance" \
--action="system=󰒓 System" \
--action="desktop=󰍹 Desktop" \
--action="keybindings=󰌌 Keybindings" | while read action; do
    case "$action" in
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
done
