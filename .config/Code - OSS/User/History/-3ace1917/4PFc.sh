#!/bin/bash

# SINGLE INSTANCE CHECK with lock file
LOCK_FILE="/tmp/power-menu.lock"

if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Power menu already running - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -x rofi
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi


echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Small delay
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

rm -f "$LOCK_FILE"