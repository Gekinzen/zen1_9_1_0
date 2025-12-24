#!/bin/bash

# --- Get all connected monitors ---
MONITORS=($(wlr-randr | grep -E ' connected' | awk '{print $1}'))

# --- Detect ultrawide and portrait monitors ---
# Simple heuristic: width > 2000 is ultrawide
for MON in "${MONITORS[@]}"; do
    MODE=$(wlr-randr | awk -v mon="$MON" '
        $1==mon {flag=1; next} 
        flag && $1 ~ /^[0-9]+x[0-9]+@/ {print $1; exit}')
    WIDTH=$(echo "$MODE" | cut -d'x' -f1)
    if [ "$WIDTH" -gt 2000 ]; then
        MAIN_MONITOR="$MON"
        MAIN_MODE="$MODE"
    else
        SECOND_MONITOR="$MON"
        SECOND_MODE="$MODE"
    fi
done

# --- Check detection ---
if [ -z "$MAIN_MONITOR" ] || [ -z "$SECOND_MONITOR" ]; then
    echo "Error: Could not detect monitors or modes"
    exit 1
fi

# --- Apply layout ---
# Lenovo portrait left (rotate 270)
LENOVO_WIDTH=$(echo "$SECOND_MODE" | cut -d'x' -f2 | cut -d'@' -f1)
wlr-randr --output "$SECOND_MONITOR" --mode "$SECOND_MODE" --pos 1x1 --rotate 270

# Ultrawide main right
MAIN_POS_X=$((LENOVO_WIDTH + 1))
wlr-randr --output "$MAIN_MONITOR" --mode "$MAIN_MODE" --pos "${MAIN_POS_X}x1" --rotate normal
