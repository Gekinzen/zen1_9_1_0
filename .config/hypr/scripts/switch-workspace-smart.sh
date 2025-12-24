#!/bin/bash

# Switch to workspace intelligently based on current monitor
WORKSPACE=$1

# Get current monitor
CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true) | .name')

# Load config
source ~/.config/hypr/workspace-monitors.conf

# Determine which workspace to switch to
if [ "$CURRENT_MONITOR" = "$PRIMARY_MONITOR" ]; then
    # On primary - use 1-8
    if [ "$WORKSPACE" -ge 1 ] && [ "$WORKSPACE" -le 8 ]; then
        hyprctl dispatch workspace "$WORKSPACE"
    fi
elif [ "$CURRENT_MONITOR" = "$SECONDARY_MONITOR" ]; then
    # On secondary - use 11-14
    case "$WORKSPACE" in
        1) hyprctl dispatch workspace 11 ;;
        2) hyprctl dispatch workspace 12 ;;
        3) hyprctl dispatch workspace 13 ;;
        4) hyprctl dispatch workspace 14 ;;
    esac
fi
