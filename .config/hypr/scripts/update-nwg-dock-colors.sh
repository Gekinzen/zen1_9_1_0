# Reload dock with new colors
if [ -f ~/.config/hypr/scripts/update-nwg-dock-colors.sh ]; then
    ~/.config/hypr/scripts/update-nwg-dock-colors.sh
fi

if [ -f ~/.config/hypr/scripts/dock-manager.sh ]; then
    echo "Refreshing nwg-dock-hyprland colors..."
    pkill -f nwg-dock-hyprland 2>/dev/null
    sleep 0.3
    
    layout=$(hyprctl getoption general:layout | grep -oE '(dwindle|master|float)' | head -n1)
    if [[ "$layout" == "float" ]]; then
        ~/.config/hypr/scripts/dock-manager.sh float &
    else
        ~/.config/hypr/scripts/dock-manager.sh tiling &
    fi
fi
