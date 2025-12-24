#!/bin/bash

# Single instance check
LOCK_FILE="/tmp/nwg-display.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "nwg-display already running"
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Launch nwg-display
nwg-displays

# After nwg-display closes, auto-fix scales
echo "Checking for invalid monitor scales..."
~/.config/hypr/scripts/fix-monitor-scale.sh

rm -f "$LOCK_FILE"
