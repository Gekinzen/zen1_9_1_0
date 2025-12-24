#!/bin/bash

single_instance_check() {
    local LOCK_NAME="$1"
    local LOCK_FILE="/tmp/${LOCK_NAME}.lock"
    
    if [ -f "$LOCK_FILE" ]; then
        PID=$(cat "$LOCK_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "$LOCK_NAME already running - closing..."
            kill "$PID" 2>/dev/null
            rm -f "$LOCK_FILE"
            pkill -f "rofi.*$LOCK_NAME"
            pkill -f "wofi.*$LOCK_NAME"
            exit 0
        else
            rm -f "$LOCK_FILE"
        fi
    fi
    
    echo $$ > "$LOCK_FILE"
    trap "rm -f $LOCK_FILE" EXIT
}