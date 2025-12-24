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

# Kill all swaync processes
pkill swaync
sleep 0.5

# Start fresh
swaync &
sleep 0.5

# Reload config and CSS
swaync-client --reload-config
swaync-client --reload-css

notify-send "Swaync" "Notification daemon restarted" -i preferences-desktop

rm -f "$LOCK_FILE"