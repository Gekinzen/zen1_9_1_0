#!/bin/bash

echo "Updating dock launcher to use rofi..."

# Kill current dock
pkill -9 nwg-dock-hyprland
sleep 0.5

# Run dock manager to regenerate configs
~/.config/hypr/scripts/dock-manager.sh start

echo "✓ Dock updated!"
echo "The launcher button (rightmost) now opens your rofi app launcher"

notify-send "󰘔 Dock" "Launcher updated to rofi" -t 2000
