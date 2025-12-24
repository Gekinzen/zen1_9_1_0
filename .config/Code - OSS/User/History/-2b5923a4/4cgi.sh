#!/bin/bash

# --- Xiaomi Ultrawide Main Monitor ---
# Assuming DP-2 is your ultrawide
wlr-randr --output DP-2 --mode 3440x1440@144 --pos 1920x0 --rotate normal

# --- Lenovo Portrait Monitor (Left Side) ---
# HDMI-A-1 rotated 270° for portrait
wlr-randr --output HDMI-A-1 --mode 1920x1080@74.95 --pos 0x0 --rotate 270

# Optional: save layout to Hyprland config (sometimes needed)
hyprctl dispatch savemonitors
