#!/bin/bash

# SINGLE INSTANCE CHECK
LOCK_FILE="/tmp/simple-run-launcher.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
        echo "Simple run launcher already running - closing..."
        kill "$PID" 2>/dev/null
        rm -f "$LOCK_FILE"
        pkill -f "wofi.*run"
        exit 0
    else
        rm -f "$LOCK_FILE"
    fi
fi
echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

# Launch wofi in RUN mode (text-based app launcher)
wofi --show run \
    --prompt "Run:" \
    --width 600 \
    --height 400 \
    --style ~/.config/wofi/simple-search-style.css \
    --allow-markup \
    --insensitive \
    --allow-images=false

rm -f "$LOCK_FILE"
