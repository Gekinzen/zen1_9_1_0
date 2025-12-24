#!/bin/bash

echo "=== Setting up Hyprland workspaces and Waybar ==="

# Step 1: Detect monitors and create config
~/.config/hypr/scripts/setup-workspaces.sh

# Step 2: Generate keybindings
~/.config/hypr/scripts/generate-workspace-keybinds.sh

# Step 3: Update Waybar config dynamically
~/.config/hypr/scripts/update-waybar-config.py

# Step 4: Restart Waybar
killall waybar 2>/dev/null
sleep 0.5
waybar &

echo "=== Setup complete! ==="
