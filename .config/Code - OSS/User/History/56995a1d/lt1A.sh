#!/bin/bash

WALLPAPER_CACHE="$HOME/.cache/current-wallpaper.jpg"
CURRENT_WP=""

# Method 1: Check pywal cache
if [ -f ~/.cache/wal/wal ]; then
    CURRENT_WP=$(cat ~/.cache/wal/wal 2>/dev/null)
fi

# Method 2: Check for pywallpaper.jpg
if [ -z "$CURRENT_WP" ] || [ ! -f "$CURRENT_WP" ]; then
    if [ -f ~/wallpapers/pywallpaper.jpg ]; then
        CURRENT_WP="$HOME/wallpapers/pywallpaper.jpg"
    elif [ -f ~/wallpapers/pywallpaper.png ]; then
        CURRENT_WP="$HOME/wallpap ers/pywallpaper.png"
    fi
fi

# Method 3: Search walls directory
if [ -z "$CURRENT_WP" ] || [ ! -f "$CURRENT_WP" ]; then
    CURRENT_WP=$(find ~/wallpapers/walls -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) 2>/dev/null | head -1)
fi

# Copy to cache
if [ -n "$CURRENT_WP" ] && [ -f "$CURRENT_WP" ]; then
    # Convert to jpg if needed and resize for performance
    convert "$CURRENT_WP" -resize 350x600 -quality 85 "$WALLPAPER_CACHE" 2>/dev/null || \
    cp "$CURRENT_WP" "$WALLPAPER_CACHE"
    
    echo "✓ Wallpaper cached: $(basename "$CURRENT_WP")"
else
    echo "✗ No wallpaper found"
    # Create a placeholder if no wallpaper
    convert -size 350x600 xc:"#151e19" "$WALLPAPER_CACHE" 2>/dev/null
fi
