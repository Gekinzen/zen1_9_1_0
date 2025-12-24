#!/bin/bash

# Sync rofi system-settings theme with pywal colors
if [ ! -f ~/.cache/wal/colors.sh ]; then
    echo "Pywal colors not found!"
    exit 1
fi

source ~/.cache/wal/colors.sh

THEME_FILE="$HOME/.config/rofi/system-settings-v3.rasi"

# Remove # from colors
BG="${background#\#}"
BG_ALT="${color1#\#}"
FG="${foreground#\#}"
SELECTED="${color12#\#}"
ACTIVE="${color10#\#}"
URGENT="${color9#\#}"

# Update theme file
cat > "$THEME_FILE" << EOF
/**
 * System Settings Theme
 * Auto-synced with pywal
 */

* {
    /* Pywal colors */
    background:     #${BG};
    background-alt: #${BG_ALT};
    foreground:     #${FG};
    selected:       #${SELECTED};
    active:         #${ACTIVE};
    urgent:         #${URGENT};
    
    /* Aliases */
    bg-col:         #${BG};
    bg-col-light:   #${BG_ALT};
    border-col:     #${SELECTED};
    selected-col:   #${SELECTED};
    fg-col:         #${FG};
    fg-col2:        #${ACTIVE};
    grey:           #565f89;
    
    font: "SF Pro Display 11";
}

EOF

echo "✓ Rofi theme synced with pywal colors"
