#!/bin/bash

LOCK_FILE="/tmp/simple-run.lock"
if [ -f "$LOCK_FILE" ]; then
    PID=$(cat "$LOCK_FILE")
    if ps -p "$PID" > /dev/null 2>&1; then
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

wofi --show run \
    --prompt "Run:" \
    --width 600 \
    --height 400 \
    --lines 8 \
    --columns 1 \
    --allow-markup \
    --insensitive \
    --no-actions \
    --style ~/.config/wofi/spotlight-style.css

rm -f "$LOCK_FILE"
```

