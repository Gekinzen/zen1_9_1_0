#!/bin/bash

echo "Monitor configuration changed!"

# Wait for monitors to settle
sleep 1

# Regenerate workspace config
~/.config/hypr/scripts/setup-workspaces.sh

# Regenerate keybindings
~/.config/hypr/scripts/generate-workspace-keybinds.sh

# Reload Hyprland
hyprctl reload

notify-send "󰍹 Monitors" "Workspaces reconfigured" -t 2000
