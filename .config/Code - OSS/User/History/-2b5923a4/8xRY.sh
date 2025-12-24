#!/bin/bash

# --- Detect monitors ---
MAIN_MONITOR="DP-2"      # Xiaomi ultrawide
SECOND_MONITOR="HDMI-A-1" # Lenovo portrait

# --- Detect first available mode for each monitor ---
MAIN_MODE=$(wlr-randr | awk -v mon="$MAIN_MONITOR" '
  $1==mon {flag=1; next} 
  flag && $1 ~ /^[0-9]+x[0-9]+@/ {print $1; exit}')
  
SECOND_MODE=$(wlr-randr | awk -v mon="$SECOND_MONITOR" '
  $1==mon {flag=1; next} 
  flag && $1 ~ /^[0-9]+x[0-9]+@/ {print $1; exit}')

# --- Check if modes were detected ---
if [ -z "$MAIN_MODE" ] || [ -z "$SECOND_MODE" ]; then
    echo "Error: Could not detect monitor modes"
    exit 1
fi

# --- Apply monitor layout ---
# Lenovo portrait left
wlr-randr --output "$SECOND_MONITOR" --mode "$SECOND_MODE" --pos 1x1 --rotate 270

# Get rotated Lenovo width (height becomes width after rotation)
LENOVO_WIDTH=$(echo "$SECOND_MODE" | cut -d'x' -f2 | cut -d'@' -f1)
MAIN_POS_X=$((LENOVO_WIDTH + 1))

# Xiaomi ultrawide main right
wlr-randr --output "$MAIN_MONITOR" --mode "$MAIN_MODE" --pos "${MAIN_POS_X}x1" --rotate normal
