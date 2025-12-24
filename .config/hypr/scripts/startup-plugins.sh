#!/bin/bash

# Wait for Hyprland
sleep 5

echo "=== Hyprbars Auto-Enable ==="
date

# Enable hyprbars
echo "Enabling hyprbars..."
hyprpm enable hyprbars

# Wait
sleep 1.5

# Reload
hyprctl reload

# Wait again
sleep 1

# Check if loaded
if hyprctl plugin list | grep -q "hyprbars"; then
    notify-send "󰖲 Hyprbars" "Enabled ✓" -t 2000 -i window-new
    echo "✓ Hyprbars loaded successfully"
else
    # Retry once
    echo "First attempt failed, retrying..."
    hyprpm enable hyprbars
    sleep 1
    hyprctl reload
    sleep 1
    
    if hyprctl plugin list | grep -q "hyprbars"; then
        notify-send "󰖲 Hyprbars" "Enabled ✓ (retry)" -t 2000 -i window-new
        echo "✓ Hyprbars loaded on retry"
    else
        notify-send "󰖲 Hyprbars" "Failed to load" -u critical
        echo "✗ Hyprbars failed to load"
    fi
fi

echo "=== Complete ==="