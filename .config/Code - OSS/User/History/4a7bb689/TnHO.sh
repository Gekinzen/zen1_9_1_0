#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyprbars.conf"

# Create config if doesn't exist
if [ ! -f "$CONFIG_FILE" ]; then
    cat > "$CONFIG_FILE" << 'EOF'
HYPERBARS_ENABLED=true
BAR_HEIGHT=32
BAR_TITLE_ENABLED=true
BUTTON_SIZE=15
EOF
fi

# Load config
source "$CONFIG_FILE"

# Check if hyperbars should be enabled
if [ "$HYPERBARS_ENABLED" = "true" ]; then
    # Check if hyprpm is available
    if command -v hyprpm &> /dev/null; then
        echo "Checking hyprbars via hyprpm..."
        
        # Check if hyprbars is in the list
        if hyprpm list | grep -q "hyprbars"; then
            # Enable it
            hyprpm enable hyprbars
            echo "Hyprbars enabled via hyprpm"
        else
            echo "Hyprbars not found in hyprpm"
            notify-send "󰖲 Hyprbars" "Plugin not found - Run: hyprpm update" -u critical
        fi
    else
        echo "hyprpm not found"
        notify-send "󰖲 Hyprbars" "hyprpm not installed" -u critical
    fi
else
    echo "Hyprbars disabled in config"
    # Disable via hyprpm
    hyprpm disable hyprbars 2>/dev/null
fi