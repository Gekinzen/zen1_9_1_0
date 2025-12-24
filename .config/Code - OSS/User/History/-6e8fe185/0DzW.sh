#!/bin/bash

if pgrep -x "wofi" > /dev/null; then
    pkill -x "wofi"
    sleep 0.2
    exit 0
fi

LOCK_FILE="/tmp/app-grid-launcher.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Already running - exiting..."
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi

echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

sleep 0.1

# Launch with specific dimensions
wofi --show drun \
    --allow-images \
    --insensitive \
    --columns 6 \
    --lines 4 \
    --width 90% \
    --height 90% \
    --xoffset 5% \
    --yoffset 5% \
    --image-size 40 \
    --prompt "Search..." \
    --style ~/.config/wofi/app-grid-pywal.css 
#wofi --show drun --style ~/.config/wofi/app-grid-pywal.css
rm -f "$LOCK_FILE"