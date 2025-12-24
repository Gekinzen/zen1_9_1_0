# ── Apply Wallpaper & Generate Colors
echo "Applying wallpaper and generating colors..."

# Your swww/hyprpaper command here
# swww img "$wallpaper" --transition-type fade --transition-duration 2

# Generate pywal colors
wal -i "$wallpaper" -n -q

# !! IMPORTANT: Wait for pywal to finish writing all color files
sleep 1

# ── Reload Services in Sequence ──

# 1. Reload Waybar first (if you have it)
if pgrep -x waybar > /dev/null; then
    echo "Reloading waybar..."
    pkill -SIGUSR2 waybar  # Soft reload
    sleep 0.5
fi

# 2. Reload other services that use pywal colors
# (rofi, dunst, kitty, etc.)
if [ -x ~/.config/dunst/launch.sh ]; then
    ~/.config/dunst/launch.sh &
fi

# Wait for everything to settle
sleep 1

# 3. Finally reload dock LAST
if [ -x ~/.config/hypr/scripts/dock-launcher.sh ]; then
    echo "Reloading nwg-dock-hyprland..."
    
    # Spawn completely independent process
    (
        # Extra delay to ensure all color files are ready
        sleep 1.5
        
        # Kill existing dock
        pkill -9 -f nwg-dock-hyprland 2>/dev/null
        killall -9 nwg-dock-hyprland 2>/dev/null
        
        # Wait for complete termination
        for i in {1..10}; do
            if ! pgrep -f nwg-dock-hyprland > /dev/null; then
                break
            fi
            sleep 0.3
        done
        
        # Launch fresh dock with new colors
        ~/.config/hypr/scripts/dock-launcher.sh
        
        # Verify
        sleep 1
        if pgrep -f nwg-dock-hyprland > /dev/null; then
            echo "$(date): ✓ Dock reloaded with new colors" >> /tmp/dock-reload.log
            notify-send "Dock reloaded" "New colorscheme applied" -t 2000
        else
            echo "$(date): ✗ Dock failed to reload" >> /tmp/dock-reload.log
            notify-send "Dock reload failed" "Check /tmp/dock-reload.log" -u critical
        fi
    ) &
    
    disown
fi

echo "Wallpaper and colors applied!"