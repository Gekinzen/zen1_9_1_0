#!/bin/bash

# --- Use jq to parse monitors ---
MAIN_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.width>2000) | .name')
SECOND_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.name != "'"$MAIN_MONITOR"'") | .name')

# --- Set exact desired modes ---
MAIN_MODE="3440x1440@144.00Hz"      # Xiaomi ultrawide
SECOND_MODE="1920x1080@74.95Hz"     # Lenovo portrait

# --- Apply layout ---
# Lenovo portrait left (270° rotation)
LENOVO_WIDTH=$(echo "$SECOND_MODE" | cut -d'x' -f2 | cut -d'@' -f1)  # rotated width
wlr-randr --output "$SECOND_MONITOR" --mode "$SECOND_MODE" --pos 1x1 --rotate 270

# Xiaomi ultrawide main right
MAIN_POS_X=$((LENOVO_WIDTH + 1))
wlr-randr --output "$MAIN_MONITOR" --mode "$MAIN_MODE" --pos "${MAIN_POS_X}x1" --rotate normal
