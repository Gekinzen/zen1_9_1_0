#!/bin/bash
# Single instance check
source ~/.config/hypr/scripts/single-instance.sh
single_instance_check "swaync-refresh"

# Refresh swaync
pkill swaync
sleep 0.5
swaync &

notify-send "Swaync" "Notification daemon refreshed" -i preferences-desktop



#pkill swaync
#swaync