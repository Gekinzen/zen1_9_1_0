#!/bin/bash
# Sync Hyprland decoration settings with Rofi themes (RGBA version)

if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    exit 1
fi

source ~/.cache/wal/colors.sh

# Get Hyprland decoration settings
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# Extract active_opacity (e.g., 0.87)
ACTIVE_OPACITY=$(grep -E "^\s*active_opacity" "$HYPR_CONF" | awk '{print $3}')
if [ -z "$ACTIVE_OPACITY" ]; then
    ACTIVE_OPACITY=1
fi

# Extract rounding
ROUNDING=$(grep -E "^\s*rounding" "$HYPR_CONF" | awk '{print $3}')
[ -z "$ROUNDING" ] && ROUNDING=0

# --- Convert hex (#RRGGBB) to RGB ---
hex_to_rgb() {
    local hex="${1#\#}"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    echo "$r,$g,$b"
}

# Get base colors
BG="${background:-#1f2648}"
BG_ALT="${color1:-#444444}"
FG="${foreground:-#ffffff}"
SELECTED="${color12:-#00bcd4}"
ACTIVE="${color10:-#00ff00}"
URGENT="${color9:-#ff0000}"

# Convert background to RGBA using Hyprland opacity
RGB=$(hex_to_rgb "$BG")
BG_RGBA="rgba(${RGB},${ACTIVE_OPACITY})"

echo "🎨 Syncing with Hyprland settings..."
echo "  Active Opacity: ${ACTIVE_OPACITY}"
echo "  Background RGB: ${RGB}"
echo "  Background RGBA: ${BG_RGBA}"
echo "  Rounding: ${ROUNDING}px"
echo ""

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

    # Backup
    cp "$THEME_FILE" "${THEME_FILE}.bak"

    # Update colors section
    sed -i "/\/\*\*\*\*\*----- Global Properties/,/\*\// {
        s|background:[[:space:]]*rgba([^;]*);|background:     ${BG_RGBA};|
        s|background:[[:space:]]*#[0-9a-fA-F]*;|background:     ${BG_RGBA};|
        s|background-alt:[[:space:]]*#[0-9a-fA-F]*;|background-alt: #${BG_ALT};|
        s|foreground:[[:space:]]*#[0-9a-fA-F]*;|foreground:     #${FG};|
        s|selected:[[:space:]]*#[0-9a-fA-F]*;|selected:       #${SELECTED};|
        s|active:[[:space:]]*#[0-9a-fA-F]*;|active:         #${ACTIVE};|
        s|urgent:[[:space:]]*#[0-9a-fA-F]*;|urgent:         #${URGENT};|
        s|border-radius:[[:space:]]*[0-9]*px;|border-radius:  ${ROUNDING}px;|
    }" "$THEME_FILE"

    echo "✓ Updated: $(basename "$THEME_FILE")"
done

echo ""
echo "✨ All Rofi themes synced successfully!"
notify-send "󰚰 Rofi Sync" "Synced with Hyprland\nOpacity: ${ACTIVE_OPACITY} | Rounding: ${ROUNDING}px" -t 2000
