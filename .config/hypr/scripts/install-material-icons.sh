#!/bin/bash

FONT_DIR="$HOME/.local/share/fonts/MaterialSymbols"
ICONS_DIR="$HOME/.config/hypr/icons"

echo "Installing Material Symbols icons..."

# Create directories
mkdir -p "$FONT_DIR"
mkdir -p "$ICONS_DIR"

# Download Material Symbols fonts
cd /tmp

# Download Material Symbols Outlined
echo "Downloading Material Symbols Outlined..."
wget -q "https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsOutlined%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf" -O MaterialSymbolsOutlined.ttf

# Download Material Symbols Rounded
echo "Downloading Material Symbols Rounded..."
wget -q "https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsRounded%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf" -O MaterialSymbolsRounded.ttf

# Download Material Symbols Sharp
echo "Downloading Material Symbols Sharp..."
wget -q "https://github.com/google/material-design-icons/raw/master/variablefont/MaterialSymbolsSharp%5BFILL%2CGRAD%2Copsz%2Cwght%5D.ttf" -O MaterialSymbolsSharp.ttf

# Install fonts
cp MaterialSymbols*.ttf "$FONT_DIR/"

# Refresh font cache
fc-cache -f

echo "Material Symbols installed successfully!"
echo "Font location: $FONT_DIR"

# Create icon mapping file
cat > "$ICONS_DIR/icon-map.conf" << 'EOF'
# Material Symbols Icon Map
# Format: NAME=CODE

# Power/System
power=󰐥
lock=󰌾
logout=󰍃
reboot=󰜉
suspend=󰒲
hibernate=󰋊

# Settings
settings=󰒓
appearance=󰏘
desktop=󰍹
keybindings=󰌌
window=󰖲
display=󰍹

# Desktop
wallpaper=󰸉
dock=󰘔
bar=󱂬
notification=󰂚

# Applications
terminal=󰆍
browser=󰖟
files=󰝰
code=󰨞
music=󰝚
video=󰕧

# Navigation
back=󰁍
forward=󰁔
up=󰁝
down=󰁅
close=󰅖

# Status
check=󰄬
error=󰅖
warning=󰀪
info=󰋽
EOF

echo "Icon map created at: $ICONS_DIR/icon-map.conf"
