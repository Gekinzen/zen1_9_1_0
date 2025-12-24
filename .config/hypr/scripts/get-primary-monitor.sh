#!/bin/bash
# Dynamically get primary/focused monitor

# Method 1: Get currently focused monitor
PRIMARY=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Method 2: Fallback to leftmost monitor (lowest x position)
if [[ -z "$PRIMARY" ]]; then
    PRIMARY=$(hyprctl monitors -j | jq -r 'sort_by(.x) | .[0].name')
fi

# Method 3: Last fallback - first monitor in list
if [[ -z "$PRIMARY" ]]; then
    PRIMARY=$(hyprctl monitors -j | jq -r '.[0].name')
fi

echo "$PRIMARY"
