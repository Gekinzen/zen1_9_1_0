#!/bin/bash

sleep 5

echo "=== Hyprbars Auto-Enable ==="
sudo hyprpm enable hyprbars
sleep 1.5
sudo hyprctl reload

if sudo hyprctl plugin list | grep -q "hyprbars"; then
    notify-send "󰖲 Hyprbars" "Enabled ✓" -t 2000 -i window-new
    echo "✓ Hyprbars loaded successfully"
else
    echo "Retrying..."
    sudo hyprpm enable hyprbars
    sleep 1
    sudo hyprctl reload
fi
