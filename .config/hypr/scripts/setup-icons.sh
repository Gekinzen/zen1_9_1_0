#!/bin/bash

BASE_DIR="$HOME/.config/hypr"
ICONS_BASE="$BASE_DIR/icons"

# Create module directories
MODULES=(
    "power"
    "system"
    "appearance"
    "desktop"
    "applications"
    "navigation"
)

echo "Creating icon module folders..."

for module in "${MODULES[@]}"; do
    mkdir -p "$ICONS_BASE/$module"
    echo "Created: $ICONS_BASE/$module"
done

# Generate SVG icons using Material Symbols
generate_icon() {
    local name=$1
    local code=$2
    local module=$3
    local color=${4:-"#c0caf5"}
    
    cat > "$ICONS_BASE/$module/$name.svg" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
    <text x="12" y="18" font-family="Material Symbols Rounded" font-size="20" fill="$color" text-anchor="middle">$code</text>
</svg>
EOF
}

# Source pywal colors
source ~/.cache/wal/colors.sh

# Power module icons
echo "Generating power module icons..."
generate_icon "lock" "" "power" "$color12"
generate_icon "logout" "" "power" "$color11"
generate_icon "suspend" "" "power" "$color10"
generate_icon "reboot" "" "power" "$color13"
generate_icon "shutdown" "" "power" "$color9"
generate_icon "hibernate" "" "power" "$color14"

# System module icons
echo "Generating system module icons..."
generate_icon "settings" "" "system" "$color12"
generate_icon "dock" "" "system" "$color10"
generate_icon "window" "" "system" "$color11"

# Appearance module icons
echo "Generating appearance module icons..."
generate_icon "theme" "" "appearance" "$color13"
generate_icon "opacity" "" "appearance" "$color14"
generate_icon "colors" "" "appearance" "$color10"

# Desktop module icons
echo "Generating desktop module icons..."
generate_icon "wallpaper" "" "desktop" "$color12"
generate_icon "bar" "" "desktop" "$color11"
generate_icon "notification" "" "desktop" "$color13"

# Applications icons
echo "Generating applications module icons..."
generate_icon "terminal" "" "applications" "$color12"
generate_icon "browser" "" "applications" "$color11"
generate_icon "files" "" "applications" "$color10"
generate_icon "code" "" "applications" "$color13"

# Navigation icons
echo "Generating navigation module icons..."
generate_icon "back" "" "navigation" "$foreground"
generate_icon "close" "" "navigation" "$color9"

echo "Icon modules created successfully!"
echo "Location: $ICONS_BASE"
tree -L 2 "$ICONS_BASE" 2>/dev/null || ls -R "$ICONS_BASE"
