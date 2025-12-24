#!/bin/bash

# Kill any existing wofi processes first (TOGGLE BEHAVIOR)
if pgrep -x "wofi" > /dev/null; then
    pkill -x "wofi"
    sleep 0.2
    exit 0
fi

# SINGLE INSTANCE CHECK
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

# Launch using config file
wofi --conf ~/.config/wofi/config \
     --style ~/.config/wofi/app-grid-pywal.css

rm -f "$LOCK_FILE"