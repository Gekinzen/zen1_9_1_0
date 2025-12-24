#!/bin/bash
# Sync Hyprland decoration settings with Rofi themes

if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    exit 1
fi

source ~/.cache/wal/colors.sh

# Get Hyprland decoration settings
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

# Extract active_opacity (e.g., 0.87)
ACTIVE_OPACITY=$(grep "^\s*active_opacity" "$HYPR_CONF" | awk '{print $3}')

# Extract rounding
ROUNDING=$(grep "^\s*rounding" "$HYPR_CONF" | awk '{print $3}')

# Function to convert hex to RGB
hex_to_rgb() {
    local hex="$1"
    # Remove # if present
    hex=$(echo "$hex" | tr -d '#')
    
    # Convert to RGB
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    
    echo "$r,$g,$b"
}

# Get base colors and convert to RGB
BG_RGB=$(hex_to_rgb "$background")
BG_ALT_RGB=$(hex_to_rgb "$color1")
FG_RGB=$(hex_to_rgb "$foreground")
SELECTED_RGB=$(hex_to_rgb "$color12")
ACTIVE_RGB=$(hex_to_rgb "$color10")
URGENT_RGB=$(hex_to_rgb "$color9")

echo "🎨 Syncing with Hyprland settings..."
echo "  Active Opacity: ${ACTIVE_OPACITY}"
echo "  Background RGBA: rgba(${BG_RGB},${ACTIVE_OPACITY})"
echo "  Rounding: ${ROUNDING}px"
echo ""

# Define theme files
THEME_FILES=(
    "$HOME/.config/rofi/system-settings-v3.rasi"
    "$HOME/.config/rofi/search-app.rasi"
)

# Function to clean double ## in color values
clean_double_hash() {
    local file="$1"
    
    # Check if may double ## sa file
    if grep -q "##[0-9a-fA-F]" "$file"; then
        echo "  🧹 Detected double ## in $(basename $file), cleaning..."
        
        # Fix all instances of ## to single #
        sed -i "/\/\*\*\*\*\*----- Global Properties/,/\*\*\*\*\*\// {
            s/##\+/#/g
        }" "$file"
        
        echo "  ✓ Cleaned double hashes"
    fi
}

# Update each theme
for THEME_FILE in "${THEME_FILES[@]}"; do
    if [ ! -f "$THEME_FILE" ]; then
        echo "⚠ Theme file not found: $THEME_FILE"
        continue
    fi
    
    # Backup
    cp "$THEME_FILE" "${THEME_FILE}.bak"
    
    # FIRST: Clean any existing double ## issues
    clean_double_hash "$THEME_FILE"
    
    # THEN: Apply new colors in RGBA format
    sed -i "
        /\/\*\*\*\*\*----- Global Properties/,/\*\*\*\*\*\// {
            s|background:[[:space:]]*[^;]*;|background:     rgba(${BG_RGB},${ACTIVE_OPACITY});|
            s|background-alt:[[:space:]]*[^;]*;|background-alt: rgba(${BG_ALT_RGB},1);|
            s|foreground:[[:space:]]*[^;]*;|foreground:     rgba(${FG_RGB},1);|
            s|selected:[[:space:]]*[^;]*;|selected:       rgba(${SELECTED_RGB},1);|
            s|active:[[:space:]]*[^;]*;|active:         rgba(${ACTIVE_RGB},1);|
            s|urgent:[[:space:]]*[^;]*;|urgent:         rgba(${URGENT_RGB},1);|
            s|border-radius:[[:space:]]*[0-9]\+px;|border-radius:  ${ROUNDING}px;|
        }
    " "$THEME_FILE"
    
    # FINAL CHECK: Verify no double ## was created
    if grep -q "##[0-9a-fA-F]" "$THEME_FILE"; then
        echo "  ⚠ Warning: Double ## still detected, running final cleanup..."
        clean_double_hash "$THEME_FILE"
    fi
    
    echo "✓ Updated: $(basename $THEME_FILE)"
done

echo ""
echo "✨ All Rofi themes synced successfully!"
notify-send "󰚰 Rofi Sync" "Synced with Hyprland\nOpacity: ${ACTIVE_OPACITY} | Rounding: ${ROUNDING}px" -t 2000