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

configuration {
    show-icons:     true;
    display-drun:   "SETTINGS";
}

window {
    transparency:        "real";
    location:            center;
    anchor:              center;
    fullscreen:          false;
    width:               1000px;
    height:              600px;
    border:              2px;
    border-color:        @border-col;
    border-radius:       16px;
    background-color:    @bg-col;
    padding:             0px;
}

mainbox {
    enabled:             true;
    spacing:             0px;
    background-color:    transparent;
    orientation:         horizontal;
    children:            [ "infobox", "listbox" ];
}

infobox {
    width:               350px;
    padding:             25px;
    background-color:    rgba(0, 0, 0, 0.3);
    border-radius:       14px 0px 0px 14px;
    orientation:         vertical;
    children:            [ "inputbar", "dummy", "message" ];
}

listbox {
    spacing:             20px;
    padding:             25px;
    background-color:    transparent;
    orientation:         vertical;
    children:            [ "listview" ];
}

dummy {
    background-color:    transparent;
    expand:              true;
}

inputbar {
    enabled:             true;
    spacing:             10px;
    padding:             12px 15px;
    margin:              0px 0px 20px 0px;
    border:              2px;
    border-radius:       12px;
    border-color:        @border-col;
    background-color:    @bg-col-light;
    text-color:          @fg-col;
    children:            [ "prompt", "entry" ];
}

prompt {
    enabled:             true;
    background-color:    transparent;
    text-color:          @selected-col;
    font:                "Material Design Icons 14";
}

entry {
    enabled:             true;
    background-color:    transparent;
    text-color:          @fg-col;
    cursor:              text;
    placeholder:         "Search...";
    placeholder-color:   @grey;
}

listview {
    enabled:             true;
    columns:             1;
    lines:               8;
    cycle:               true;
    dynamic:             true;
    scrollbar:           false;
    layout:              vertical;
    reverse:             false;
    fixed-height:        true;
    fixed-columns:       true;
    spacing:             8px;
    background-color:    transparent;
    text-color:          @fg-col;
}

element {
    enabled:             true;
    spacing:             15px;
    padding:             14px;
    border:              2px;
    border-radius:       12px;
    border-color:        transparent;
    background-color:    transparent;
    text-color:          @fg-col;
    cursor:              pointer;
}

element normal.normal {
    background-color:    transparent;
    text-color:          @fg-col;
}

element selected.normal {
    background-color:    rgba(122, 162, 247, 0.25);
    border-color:        @selected-col;
    text-color:          @fg-col;
}

element alternate.normal {
    background-color:    transparent;
    text-color:          @fg-col;
}

element-icon {
    background-color:    transparent;
    text-color:          inherit;
    size:                32px;
    cursor:              inherit;
}

element-text {
    background-color:    transparent;
    text-color:          inherit;
    cursor:              inherit;
    vertical-align:      0.5;
    horizontal-align:    0.0;
    font:                "SF Pro Display Medium 12";
}

message {
    enabled:             true;
    padding:             0px;
    margin:              0px;
    background-color:    transparent;
}

textbox {
    padding:             15px;
    border-radius:       12px;
    background-color:    rgba(0, 0, 0, 0.2);
    text-color:          @fg-col;
    vertical-align:      0.0;
    horizontal-align:    0.0;
    font:                "SF Pro Display 10";
}

error-message {
    padding:             20px;
    border-radius:       12px;
    background-color:    @bg-col;
    text-color:          @fg-col;
}
EOF

echo "✓ Rofi theme synced with pywal colors"
