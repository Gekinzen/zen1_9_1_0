#!/bin/bash

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/swaync-refresh.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Swaync refresh already running - exiting..."
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Check if swaync is running
if pgrep -x "swaync" > /dev/null; then
    swaync-client --reload-config
    swaync-client --reload-css
    notify-send "Swaync" "Configuration reloaded" -i preferences-desktop
else
    swaync &
    notify-send "Swaync" "Notification daemon started" -i preferences-desktop
fi

rm -f "$LOCK_FILE"