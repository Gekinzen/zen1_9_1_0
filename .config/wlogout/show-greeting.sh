#!/bin/bash

USERNAME=$(whoami)
UPTIME=$(uptime -p | sed 's/up //')
DATE=$(date +"%A, %B %d")

# Create greeting overlay using eww or similar
# Or use notification
notify-send "Goodbye $USERNAME" "Uptime: $UPTIME\n$DATE" \
    -t 3000 \
    -i system-shutdown \
    -u normal

# Small delay before showing wlogout
sleep 0.5

# Launch wlogout
~/.config/wlogout/launch-wlogout.sh
