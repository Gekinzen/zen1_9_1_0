#!/bin/bash
killall rofi 2>/dev/null
sleep 0.2

OPTIONS="Lock\nSuspend\nLogout\nReboot\nShutdown"
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -p "Power")

case "$CHOICE" in
    "Lock") hyprlock ;;
    "Suspend") systemctl suspend ;;
    "Logout") hyprctl dispatch exit ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff -i ;;
esac
