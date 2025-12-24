#!/bin/bash

# SINGLE INSTANCE CHECK - Toggle behavior
if pgrep -x rofi > /dev/null; then
    pkill -x rofi
    exit 0
fi

# Small delay to ensure clean state
sleep 0.1

# Get uptime
UPTIME=$(uptime -p | sed 's/up //')

# Show menu
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