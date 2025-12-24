#!/bin/bash

# Show visual indicator using notification
notify-send -t 0 -u critical -i system-shutdown "Power Mode Active" \
"Press a key:
━━━━━━━━━━━━━━━━━━━━━━
🔒  L  =  Lock Screen
💤  S  =  Suspend
🚪  E  =  Logout
🔄  R  =  Reboot
⏻  P  =  Shutdown
💾  H  =  Hibernate

ESC or Q = Cancel" \
--app-name="PowerMode" \
--hint=string:synchronous:power-mode

# Optional: Create a visual overlay with waybar or eww
# Or dim the screen slightly
# hyprctl keyword decoration:dim_inactive 0.8
