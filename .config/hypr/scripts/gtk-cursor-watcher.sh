#!/bin/bash

GTK_SETTINGS="$HOME/.config/gtk-3.0/settings.ini"

# Watch for changes to GTK settings file
while inotifywait -e modify "$GTK_SETTINGS" 2>/dev/null; do
    sleep 0.5  # Small delay to ensure file is fully written
    
    # Run your apply cursor script
    ~/.config/hypr/scripts/apply-cursor.sh
done
