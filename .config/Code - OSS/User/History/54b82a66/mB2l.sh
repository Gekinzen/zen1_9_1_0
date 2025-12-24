#!/bin/bash

# Wait for Hyprland to fully start
sleep 3

echo "=== Hyprbars Startup Script ==="
date

# Check if hyprpm is available
if ! command -v hyprpm &> /dev/null; then
    echo "ERROR: hyprpm not found"
    notify-send "󰖲 Hyprbars" "hyprpm not found" -u critical
    exit 1
fi

# Load hyprbars config
CONFIG_FILE="$HOME/.config/hypr/hyperbars.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    echo "Config loaded: HYPERBARS_ENABLED=$HYPERBARS_ENABLED"
else
    HYPERBARS_ENABLED=true
    echo "No config found, defaulting to enabled"
    cat > "$CONFIG_FILE" << 'EOF'
HYPERBARS_ENABLED=true
BAR_HEIGHT=38
BAR_TITLE_ENABLED=false
BUTTON_SIZE=17
GLASS_ENABLED=true
EOF
fi

# Enable hyprbars if configured
if [ "$HYPERBARS_ENABLED" = "true" ]; then
    echo "Enabling hyprbars..."
    
    # Check if plugin exists
    if hyprpm list | grep -q "hyprbars"; then
        # Enable plugin
        hyprpm enable hyprbars
        
        # Wait for it to load
        sleep 1
        
        # Reload Hyprland
        hyprctl reload
        
        # Wait again
        sleep 0.5
        
        # Verify
        if hyprctl plugin list | grep -q "hyprbars"; then
            notify-send "󰖲 Hyprbars" "Loaded successfully" -t 2000 -i window-new
            echo "SUCCESS: Hyprbars loaded"
        else
            notify-send "󰖲 Hyprbars" "Failed to load - Trying again..." -u critical
            echo "ERROR: Hyprbars not loaded, retrying..."
            
            # Retry once
            sleep 1
            hyprpm enable hyprbars
            sleep 1
            hyprctl reload
        fi
    else
        echo "ERROR: Hyprbars not found in hyprpm list"
        notify-send "󰖲 Hyprbars" "Plugin not found - Run: hyprpm update" -u critical
    fi
else
    echo "Hyprbars disabled in config"
fi

echo "=== Startup script complete ==="