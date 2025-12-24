#!/bin/bash

# Universal Single Instance Function
# Usage: single_instance_check "script-name"
single_instance_check() {
    local SCRIPT_NAME="$1"
    local LOCK_FILE="/tmp/${SCRIPT_NAME}.lock"
    
    if [ -f "$LOCK_FILE" ]; then
        PID=$(cat "$LOCK_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            echo "$SCRIPT_NAME already running (PID: $PID) - closing..."
            kill "$PID" 2>/dev/null
            rm -f "$LOCK_FILE"
            # Kill any related wofi/rofi instances
            pkill -f "wofi.*$SCRIPT_NAME"
            pkill -f "rofi.*$SCRIPT_NAME"
            exit 0
        else
            # Stale lock file, remove it
            rm -f "$LOCK_FILE"
        fi
    fi
    
    # Create lock file
    echo $$ > "$LOCK_FILE"
    trap "rm -f $LOCK_FILE" EXIT
}

# Export the function
export -f single_instance_check
