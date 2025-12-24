#!/bin/bash

ICONS_DIR="$HOME/.config/hypr/icons"

# Function to get icon path
get_icon() {
    local module=$1
    local name=$2
    echo "$ICONS_DIR/$module/$name.svg"
}

# Function to get icon with pywal color
get_colored_icon() {
    local module=$1
    local name=$2
    local color=$3
    
    source ~/.cache/wal/colors.sh
    
    # Get color variable value
    eval "icon_color=\$$color"
    
    # Generate temporary colored icon
    local temp_icon="/tmp/icon-${module}-${name}.svg"
    
    cat > "$temp_icon" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="48" height="48">
    <text x="12" y="18" font-family="Material Symbols Rounded" font-size="20" fill="${icon_color}" text-anchor="middle">$(cat "$ICONS_DIR/$module/codes/$name.txt")</text>
</svg>
EOF
    
    echo "$temp_icon"
}

# Export functions
export -f get_icon
export -f get_colored_icon
