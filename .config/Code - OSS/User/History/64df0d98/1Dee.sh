#!/bin/bash

# Sync only color variables with pywal
if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    exit 1
fi

source ~/.cache/wal/colors.sh

THEME_FILE="$HOME/.config/rofi/system-settings-v3.rasi"

# Backup
cp "$THEME_FILE" "${THEME_FILE}.bak"

# Remove # from colors
BG="${background#\#}"
BG_ALT="${color1#\#}"
FG="${foreground#\#}"
SELECTED="${color12#\#}"
ACTIVE="${color10#\#}"
URGENT="${color9#\#}"

# Only update the color variables section
sed -i "/\/\*\*\*\*\*----- Global Properties/,/\*\// {
    s/background:.*#[0-9a-fA-F]\{6\};/background:     #${BG};/
    s/background-alt:.*#[0-9a-fA-F]\{6\};/background-alt: #${BG_ALT};/
    s/foreground:.*#[0-9a-fA-F]\{6\};/foreground:     #${FG};/
    s/selected:.*#[0-9a-fA-F]\{6\};/selected:       #${SELECTED};/
    s/active:.*#[0-9a-fA-F]\{6\};/active:         #${ACTIVE};/
    s/urgent:.*#[0-9a-fA-F]\{6\};/urgent:         #${URGENT};/
}" "$THEME_FILE"

echo "✓ Rofi colors synced with pywal"
notify-send "󰚰 Rofi" "Colors updated" -t 1000