#!/bin/bash

# SINGLE INSTANCE CHECK
if pgrep -x "wlogout" > /dev/null; then
    echo "Wlogout already running - closing it..."
    pkill -x wlogout
    exit 0
fi

# Configuration
CONFIG_FILE="$HOME/.config/wlogout/config.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    MGN=10
    HVR=20
    BUTTON_RAD=20
    ACTIVE_RAD=80
    FNT_SIZE=18
    ENABLE_WALLPAPER=true
fi

# Get current wallpaper from pywal cache
WALLPAPER_PATH=""
if [ -f "$HOME/.cache/wal/wal" ]; then
    WALLPAPER_PATH=$(cat "$HOME/.cache/wal/wal")
    echo "Current wallpaper: $WALLPAPER_PATH"
fi

# AUTO-DETECT MONITOR with TRANSFORM support
MONITOR_JSON=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true)')
WIDTH=$(echo "$MONITOR_JSON" | jq -r '.width')
HEIGHT=$(echo "$MONITOR_JSON" | jq -r '.height')
TRANSFORM=$(echo "$MONITOR_JSON" | jq -r '.transform')

echo "Monitor: ${WIDTH}x${HEIGHT}, Transform: ${TRANSFORM}"

# Check transform and swap dimensions if rotated
case $TRANSFORM in
    0|2)
        ACTUAL_WIDTH=$WIDTH
        ACTUAL_HEIGHT=$HEIGHT
        ;;
    1|3)
        ACTUAL_WIDTH=$HEIGHT
        ACTUAL_HEIGHT=$WIDTH
        ;;
    *)
        ACTUAL_WIDTH=$WIDTH
        ACTUAL_HEIGHT=$HEIGHT
        ;;
esac

echo "Actual orientation: ${ACTUAL_WIDTH}x${ACTUAL_HEIGHT}"

# RESPONSIVE LAYOUT & SPACING
if [ $ACTUAL_WIDTH -gt $ACTUAL_HEIGHT ]; then
    COLS=7
    ROWS=1
    LAYOUT="horizontal"
    
    if [ $ACTUAL_WIDTH -ge 3440 ]; then
        BUTTON_SPACING=6
    elif [ $ACTUAL_WIDTH -ge 2560 ]; then
        BUTTON_SPACING=6
    elif [ $ACTUAL_WIDTH -ge 1920 ]; then
        BUTTON_SPACING=6
    else
        BUTTON_SPACING=6
    fi
    
    echo "Layout: HORIZONTAL (3x2), Spacing: $BUTTON_SPACING"
else
    COLS=1
    ROWS=6
    LAYOUT="vertical"
    
    if [ $ACTUAL_WIDTH -ge 1920 ]; then
        BUTTON_SPACING=1
    elif [ $ACTUAL_WIDTH -ge 1440 ]; then
        BUTTON_SPACING=1
    elif [ $ACTUAL_WIDTH -ge 1080 ]; then
        BUTTON_SPACING=1
    else
        BUTTON_SPACING=1
    fi
    
    echo "Layout: VERTICAL (2x3), Spacing: $BUTTON_SPACING"
fi

# Generate CSS
cat > "$HOME/.config/wlogout/style.css" << EOF
@import url("$HOME/.cache/wal/colors-wlogout.css");

* {
    background-image: none;
    font-size: ${FNT_SIZE}px;
    transition: 20ms;
    box-shadow: none;
}

window {
EOF

# Add wallpaper or solid color based on setting
if [ "$ENABLE_WALLPAPER" = "true" ] && [ -n "$WALLPAPER_PATH" ] && [ -f "$WALLPAPER_PATH" ]; then
    echo "    /* Wallpaper background enabled */" >> "$HOME/.config/wlogout/style.css"
    echo "    background-image: linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url('$WALLPAPER_PATH');" >> "$HOME/.config/wlogout/style.css"
    echo "    background-size: cover;" >> "$HOME/.config/wlogout/style.css"
    echo "    background-position: center;" >> "$HOME/.config/wlogout/style.css"
    echo "Wallpaper background: ENABLED"
else
    echo "    /* Solid color background */" >> "$HOME/.config/wlogout/style.css"
    echo "    background-color: rgba(12, 12, 12, 0.8);" >> "$HOME/.config/wlogout/style.css"
    echo "Wallpaper background: DISABLED"
fi

cat >> "$HOME/.config/wlogout/style.css" << 'EOF'
    font-size: 16pt;
    border-radius: 15px;
}
window {
	background-size: 30%;
}
button {
    background-repeat: no-repeat;
    background-position: center;
    background-size: 30%;
    background-color: transparent;
    animation: gradient_f 20s ease-in infinite;
    transition: all 0.3s ease-in;
    box-shadow: 0 0 10px 2px transparent;
    border-radius: 36px;
    margin: 10px;
    padding-left: 30px;
    padding-right: 30px;
    padding-bottom:50px;
    padding-top:50px;
}

button:focus {
    box-shadow: none;
    background-size : 20%;
    background-color: transparent;
}

button:hover {
    background-size: 50%;
    box-shadow: 0 0 10px 3px rgba(0,0,0,.4);
    background-color: transparent;
    /* background-color: @color6;*/
    color: transparent;
    transition: all 0.3s cubic-bezier(.55, 0.0, .28, 1.682), box-shadow 0.5s ease-in;
}

#shutdown {
    background-image: image(url("./icons/power.png"));
}
#shutdown:hover {
  background-image: image(url("./icons/power-hover.png"));
}

#logout {
    background-image: image(url("./icons/logout.png"));

}
#logout:hover {
  background-image: image(url("./icons/logout-hover.png"));
}

#reboot {
    background-image: image(url("./icons/restart.png"));
}
#reboot:hover {
  background-image: image(url("./icons/restart-hover.png"));
}

#lock {
    background-image: image(url("./icons/lock.png"));
}
#lock:hover {
  background-image: image(url("./icons/lock-hover.png"));
}

#hibernate {
    background-image: image(url("./icons/hibernate.png"));
}
#hibernate:hover {
  background-image: image(url("./icons/hibernate-hover.png"));
}
EOF

echo "CSS generated"
echo "Launching wlogout with spacing: $BUTTON_SPACING"

# Launch wlogout
wlogout -b $BUTTON_SPACING -c $COLS -r $ROWS