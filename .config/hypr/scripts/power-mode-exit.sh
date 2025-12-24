#!/bin/bash

# Close the notification
pkill -f "Power Mode Active"
notify-send --close=0

# Reset screen dimming if you enabled it
# hyprctl keyword decoration:dim_inactive 0.6
