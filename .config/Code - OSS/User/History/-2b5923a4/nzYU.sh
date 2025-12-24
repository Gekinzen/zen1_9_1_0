#!/bin/bash

# --- Detect monitors and modes ---
# DP-2 = main ultrawide
# HDMI-A-1 = Lenovo portrait

MAIN_MONITOR=$(wlr-randr | grep -E 'DP-2|HDMI-A-1' | grep -v 'HDMI-A-1' | awk '{print $1}')
SECOND_MONITOR=$(wlr-randr | grep 'HDMI-A-1' | awk '{print $1}')

# Get exact mode (resolution@refresh) for each monitor
MAIN_MODE=$(wlr-randr | grep -A 10 "$MAIN_MONITOR" | grep -E '^[[:space:]]+[0-9]+x[0-9]+@[0-9.]+' | head -n1 | awk '{$1=$1; print $1}')
SECOND_MODE=$(wlr-randr | grep -A 10 "$SECOND_MONITOR" | grep -E '^[[:space:]]+[0-9]+x[0-9]+@[0-9.]+' | head -n1 | awk '{$1=$1; print $1}')

# --- Apply monitor layout ---
# Lenovo portrait left
wlr-randr --output "$SECOND_MONITOR" --mode "$SECOND_MODE" --pos 1x1 --rotate 270

# Xiaomi ultrawide main right
# Get width of Lenovo rotated to place main monitor correctly
LENOVO_WIDTH=$(echo "$SECOND_MODE" | awk -Fx '{print $2}')  # Use height because rotated
MAIN_POS_X=$((LENOVO_WIDTH + 1))
wlr-randr --output "$MAIN_MONITOR" --mode "$MAIN_MODE" --pos "${MAIN_POS_X}x1" --rotate normal
