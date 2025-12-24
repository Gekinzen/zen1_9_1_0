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

# Launch simple wofi - dmenu mode (text search, no icons)
wofi --show dmenu \
    --prompt "Run:" \
    --width 600 \
    --height 400 \
    --style ~/.config/wofi/simple-search-style.css \
    --allow-markup \
    --insensitive

rm -f "$LOCK_FILE"