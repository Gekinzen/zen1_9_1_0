#!/bin/bash

LOCK_FILE="/tmp/simple-wofi-menu.lock"
COOLDOWN=0.3  # 300ms cooldown

# Kill existing wofi
if pgrep -x "wofi" > /dev/null; then
    pkill -x "wofi"
    sleep $COOLDOWN
    exit 0
fi

# Check if recently launched (cooldown)
if [ -f "$LOCK_FILE" ]; then
    LAST_RUN=$(stat -c %Y "$LOCK_FILE" 2>/dev/null || echo 0)
    CURRENT_TIME=$(date +%s)
    TIME_DIFF=$((CURRENT_TIME - LAST_RUN))
    
    if [ $TIME_DIFF -lt 1 ]; then
        echo "Cooldown active, please wait..."
        exit 0
    fi
fi

echo $$ > "$LOCK_FILE"
trap "rm -f $LOCK_FILE" EXIT

wofi --show drun \
    --prompt "Search..." \
    --width 450 \
    --height 200 \
    --lines 5 \
    --columns 1 \
    --allow-markup \
    --insensitive \
    --no-actions \
    --style ~/.config/wofi/spotlight-style.css

rm -f "$LOCK_FILE"