#!/bin/bash

# Usage: check-keybind-conflict.sh "SUPER" "T"
MOD="$1"
KEY="$2"

# Check if binding exists
EXISTING=$(grep -E "bind.*=.*$MOD.*,.*$KEY," "$HOME/.config/hypr/hyprland.conf")

if [ -n "$EXISTING" ]; then
    # Conflict found
    CONFLICT_ACTION=$(echo "$EXISTING" | awk -F'exec,' '{print $2}' | cut -d'#' -f1)
    
    CHOICE=$(echo -e "⚠️ Keybind Conflict Detected!\n\n$MOD+$KEY is already bound to:\n$CONFLICT_ACTION\n---\n🔄 Override\n❌ Cancel" | \
        wofi --dmenu --prompt "Keybind Conflict" --width 500 --height 300)
    
    if [ "$CHOICE" = "🔄 Override" ]; then
        echo "OVERRIDE"
        exit 0
    else
        echo "CANCEL"
        exit 1
    fi
else
    echo "OK"
    exit 0
fi
