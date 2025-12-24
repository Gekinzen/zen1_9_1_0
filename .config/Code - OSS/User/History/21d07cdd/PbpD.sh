#!/bin/bash

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/simple-wofi-menu.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Simple wofi menu already running - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "wofi.*dmenu"
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Launch elegant single-column wofi (like macOS Spotlight)
wofi --show drun \
    --prompt "Search..." \
    --width 550 \
    --height 100 \
    --lines 3 \
    --columns 1 \
    --allow-images \
    --allow-markup \
    --insensitive \
    --no-actions \
    --style ~/.config/wofi/spotlight-style.css

rm -f "$LOCK_FILE"