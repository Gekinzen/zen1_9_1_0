#!/bin/bash

echo "=========================================="
echo "Setting up Hyprbars (hyprpm version)"
echo "=========================================="

# 1. Check if hyprpm is available
echo "1. Checking hyprpm..."
if ! command -v hyprpm &> /dev/null; then
    echo "   ✗ hyprpm not found!"
    echo "   Install Hyprland from git for hyprpm support"
    exit 1
fi
echo "   ✓ hyprpm found"

# 2. Check if hyprland-plugins repo is added
echo "2. Checking hyprland-plugins repo..."
if hyprpm list | grep -q "hyprland-plugins"; then
    echo "   ✓ Repository already added"
else
    echo "   Adding repository..."
    hyprpm add https://github.com/hyprwm/hyprland-plugins
    echo "   Updating..."
    hyprpm update
fi

# 3. Enable hyprbars
echo "3. Enabling hyprbars..."
hyprpm enable hyprbars

# 4. Verify installation
echo "4. Verifying..."
if hyprpm list | grep -q "enabled.*hyprbars"; then
    echo "   ✓ Hyprbars enabled successfully!"
else
    echo "   ✗ Hyprbars not enabled"
    echo "   Try running: hyprpm enable hyprbars"
fi

# 5. Create config
echo "5. Creating config..."
cat > ~/.config/hypr/hyprbars.conf << 'EOF'
HYPERBARS_ENABLED=true
BAR_HEIGHT=32
BAR_TITLE_ENABLED=true
BUTTON_SIZE=15
EOF

# 6. Make scripts executable
echo "6. Making scripts executable..."
chmod +x ~/.config/hypr/scripts/hyprbars-*.sh

# 7. Reload Hyprland
echo "7. Reloading Hyprland..."
hyprctl reload

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "=========================================="
echo ""
echo "Check status:"
echo "  hyprpm list"
echo ""
echo "Controls:"
echo "  • System Settings → Appearance → Window Decorations"
echo "  • ~/.config/hypr/scripts/hyprbars-manager.sh toggle"
echo ""
echo "Manual commands:"
echo "  • Enable:  hyprpm enable hyprbars"
echo "  • Disable: hyprpm disable hyprbars"
echo "  • Update:  hyprpm update"
