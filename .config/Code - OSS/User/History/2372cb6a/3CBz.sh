#!/bin/bash

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/waybar-refresh.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Waybar refresh already running - exiting..."
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Check if waybar is running
if pgrep -x "waybar" > /dev/null; then
    pkill -x "waybar"
    sleep 0.3
    waybar &
    notify-send "Waybar" "Refreshed" -i preferences-desktop
else
    waybar &
    notify-send "Waybar" "Started" -i preferences-desktop
fi

rm -f "$LOCK_FILE"