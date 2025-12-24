#!/bin/bash

# Minimize window (move to special workspace)
hyprctl dispatch movetoworkspacesilent special:minimized
notify-send "󰖰 Window" "Minimized" -t 1000
