#!/bin/bash

CONFIG_FILE="$HOME/.config/hypr/hyperbars.conf"

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
        echo "Enabling hyprbars via hyprpm..."
        
        # Enable hyprbars on startup
        hyprpm enable hyprbars
        
        # Give it a moment to load
        sleep 0.5
        
        # Reload to apply
        hyprctl reload
        
        notify-send "󰖲 Hyprbars" "Enabled" -t 2000 -i window-new
    else
        echo "hyprpm not found"
        notify-send "󰖲 Hyprbars" "hyprpm not installed" -u critical
    fi
else
    echo "Hyprbars disabled in config"
    # Disable via hyprpm
    hyprpm disable hyprbars 2>/dev/null
fi