#!/bin/bash

# Rofi Pywal Color Sync

ROFI_THEME="$HOME/.config/rofi/pywal-grid.rasi"

# Source pywal colors
source ~/.cache/wal/colors.sh

# Update rofi theme with pywal colors
sed -i "s/background:.*$/background:     $color0;/" "$ROFI_THEME"
sed -i "s/background-alt:.*$/background-alt: $color8;/" "$ROFI_THEME"
sed -i "s/foreground:.*$/foreground:     $foreground;/" "$ROFI_THEME"
sed -i "s/selected:.*$/selected:       $color12;/" "$ROFI_THEME"
sed -i "s/active:.*$/active:         $color10;/" "$ROFI_THEME"
sed -i "s/urgent:.*$/urgent:         $color9;/" "$ROFI_THEME"

notify-send "Rofi Theme" "Synced with pywal colors" -i preferences-desktop-theme
