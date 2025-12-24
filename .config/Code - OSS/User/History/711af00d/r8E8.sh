# ── Reload Dock 20251104
if [ -x ~/.config/hypr/scripts/dock-manager.sh ]; then
    echo "Refreshing nwg-dock-hyprland colors..."
    
    # Determine current layout
    layout=$(hyprctl getoption general:layout | grep -oE '(dwindle|master|float)' | head -n1)
    [[ -z "$layout" ]] && layout="tiling"

    # Call dock-manager with layout
    ~/.config/hypr/scripts/dock-manager.sh "$layout" &
fi
