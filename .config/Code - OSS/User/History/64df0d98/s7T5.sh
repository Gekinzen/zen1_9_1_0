#!/bin/bash
# Sync color variables with pywal to multiple rofi themes

if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    exit 1
fi

source ~/.cache/wal/colors.sh

# Define all theme files to update
THEME_FILES=(
    "$HOME/.config/rofi/system-settings-v3.rasi"
    "$HOME/.config/rofi/search-app.rasi"
)

# Remove # from colors
BG="${background#\#}"
BG_ALT="${color1#\#}"
FG="${foreground#\#}"
SELECTED="${color12#\#}"
ACTIVE="${color10#\#}"
URGENT="${color9#\#}"

# Update each theme file
for THEME_FILE in "${THEME_FILES[@]}"; do
    if [ ! -f "$THEME_FILE" ]; then
        echo "⚠ Theme file not found: $THEME_FILE"
        continue
    fi
    
    # Backup
    cp "$THEME_FILE" "${THEME_FILE}.bak"
    
    # Only update the color variables section
    sed -i "/\/\*\*\*\*\*----- Global Properties/,/\*\// {
        s/background:.*#[0-9a-fA-F]\{6\};/background:     #${BG};/
        s/background-alt:.*#[0-9a-fA-F]\{6\};/background-alt: #${BG_ALT};/
        s/foreground:.*#[0-9a-fA-F]\{6\};/foreground:     #${FG};/
        s/selected:.*#[0-9a-fA-F]\{6\};/selected:       #${SELECTED};/
        s/active:.*#[0-9a-fA-F]\{6\};/active:         #${ACTIVE};/
        s/urgent:.*#[0-9a-fA-F]\{6\};/urgent:         #${URGENT};/
    }" "$THEME_FILE"
    
    echo "✓ Updated: $(basename $THEME_FILE)"
done

echo ""
echo "✓ All Rofi themes synced with pywal"
notify-send "󰚰 Rofi" "All themes updated" -t 1000