#!/bin/bash

# Kill existing rofi and wait
pkill rofi 2>/dev/null
sleep 0.3

# Get uptime
UPTIME=$(uptime -p | sed 's/up //')

# Check if custom theme exists
THEME_FILE="$HOME/.config/rofi/power-menu.rasi"
if [ -f "$THEME_FILE" ]; then
    THEME_ARG="-theme $THEME_FILE"
else
    THEME_ARG=""
fi

# Show menu
CHOICE=$(echo -e "🔒 Lock\n💤 Suspend\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown\n💾 Hibernate" | \
    rofi -dmenu -i \
    -p "Power Menu" \
    -mesg "Uptime: $UPTIME" \
    $THEME_ARG)

# Execute choice
case "$CHOICE" in
    *"Lock"*) hyprlock ;;
    *"Suspend"*) systemctl suspend ;;
    *"Logout"*) hyprctl dispatch exit ;;
    *"Reboot"*) systemctl reboot ;;
    *"Shutdown"*) systemctl poweroff -i ;;
    *"Hibernate"*) systemctl hibernate ;;
esac