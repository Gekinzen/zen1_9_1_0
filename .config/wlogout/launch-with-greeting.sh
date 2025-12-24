#!/bin/bash

# Get user info
USERNAME=$(whoami)
UPTIME=$(uptime -p | sed 's/up //')
DATE=$(date +"%A, %B %d, %I:%M %p")

# Show greeting with swaync (if you have it)
notify-send -t 2000 -u normal -i face-smile "Goodbye $USERNAME" "System uptime: $UPTIME\n$DATE"

# Small delay
sleep 0.3

# Launch wlogout
~/.config/wlogout/launch-wlogout.sh
