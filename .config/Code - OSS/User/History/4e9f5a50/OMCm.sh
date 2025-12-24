#!/bin/bash

# Kill existing rofi and wait
pkill rofi 2>/dev/null
sleep 0.2

# Get uptime
UPTIME=$(uptime -p | sed 's/up //')

echo "Debug: Uptime = $UPTIME"
echo "Debug: Launching rofi..."

# Show menu (with debug)
CHOICE=$(echo -e "🔒 Lock\n💤 Suspend\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown\n💾 Hibernate" | \
    rofi -dmenu -i \
    -p "Power Menu" \
    -mesg "Uptime: $UPTIME" \
    -theme ~/.config/rofi/power-menu.rasi 2>&1)

echo "Debug: Choice = $CHOICE"

case "$CHOICE" in
    *"Lock"*) 
        echo "Executing: hyprlock"
        hyprlock 
        ;;
    *"Suspend"*) 
        echo "Executing: suspend"
        systemctl suspend 
        ;;
    *"Logout"*) 
        echo "Executing: logout"
        hyprctl dispatch exit 
        ;;
    *"Reboot"*) 
        echo "Executing: reboot"
        systemctl reboot 
        ;;
    *"Shutdown"*) 
        echo "Executing: shutdown"
        systemctl poweroff -i 
        ;;
    *"Hibernate"*) 
        echo "Executing: hibernate"
        systemctl hibernate 
        ;;
    *)
        echo "Debug: No valid choice or cancelled"
        ;;
esac