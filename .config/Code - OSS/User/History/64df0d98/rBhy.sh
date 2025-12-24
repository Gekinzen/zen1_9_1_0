#!/bin/bash
# Sync Hyprland decoration settings with Rofi themes

if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    exit 1
fi

source ~/.cache/wal/colors.sh

# Get Hyprland decoration settings
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# Extract active_opacity (e.g., 0.87 -> 87)
ACTIVE_OPACITY=$(grep "active_opacity" "$HYPR_CONF" | awk '{print $3}' | sed 's/^0\.//')
# Convert to hex alpha (0.87 * 255 = 221.85 → DD in hex)
ALPHA=$(printf '%02X' $(echo "$ACTIVE_OPACITY * 2.55" | bc | cut -d. -f1))

# Extract rounding
ROUNDING=$(grep "rounding" "$HYPR_CONF" | head -1 | awk '{print $3}')

# Get base colors
BG="${background#\#}"
BG_ALT="${color1#\#}"
FG="${foreground#\#}"
SELECTED="${color12#\#}"
ACTIVE="${color10#\#}"
URGENT="${color9#\#}"

# Create alpha variant
BG_ALPHA="${BG}${ALPHA}"

# Define theme files
THEME_FILES=(
    "$HOME/.config/rofi/system-settings-v3.rasi"
    "$HOME/.config/rofi/search-app.rasi"
)

# Update each theme
for THEME_FILE in "${THEME_FILES[@]}"; do
    if [ ! -f "$THEME_FILE" ]; then
        echo "⚠ Theme file not found: $THEME_FILE"
        continue
    fi
    
    cp "$THEME_FILE" "${THEME_FILE}.bak"
    
    sed -i "/\/\*\*\*\*\*----- Global Properties/,/\*\// {
        s/background:.*#[0-9a-fA-F]\{6,8\};/background:     #${BG_ALPHA};/
        s/background-alt:.*#[0-9a-fA-F]\{6\};/background-alt: #${BG_ALT};/
        s/foreground:.*#[0-9a-fA-F]\{6\};/foreground:     #${FG};/
        s/selected:.*#[0-9a-fA-F]\{6\};/selected:       #${SELECTED};/
        s/active:.*#[0-9a-fA-F]\{6\};/active:         #${ACTIVE};/
        s/urgent:.*#[0-9a-fA-F]\{6\};/urgent:         #${URGENT};/
        s/border-radius:.*[0-9]\+px;/border-radius:  ${ROUNDING}px;/
    }" "$THEME_FILE"
    
    echo "✓ Updated: $(basename $THEME_FILE)"
done

echo ""
echo "✓ Synced with Hyprland settings:"
echo "  - Opacity: ${ACTIVE_OPACITY}% (Alpha: ${ALPHA})"
echo "  - Rounding: ${ROUNDING}px"
notify-send "󰚰 Rofi" "Themes synced with Hyprland" -t 1500