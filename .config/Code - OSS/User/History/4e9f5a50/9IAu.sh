#!/bin/bash

# Kill ONLY the exact "rofi" process (not scripts containing "rofi")
pkill -x rofi 2>/dev/null
sleep 0.2

UPTIME=$(uptime -p | sed 's/up //')

CHOICE=$(echo -e "🔒 Lock\n💤 Suspend\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown\n💾 Hibernate" | \
    rofi -dmenu -i \
    -p "Power Menu" \
    -mesg "Uptime: $UPTIME" \
    -theme ~/.config/rofi/power-menu.rasi)

case "$CHOICE" in
    *"Lock"*) hyprlock ;;
    *"Suspend"*) systemctl suspend ;;
    *"Logout"*) hyprctl dispatch exit ;;
    *"Reboot"*) systemctl reboot ;;
    *"Shutdown"*) systemctl poweroff -i ;;
    *"Hibernate"*) systemctl hibernate ;;
esac