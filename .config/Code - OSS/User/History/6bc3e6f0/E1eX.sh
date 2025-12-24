#!/bin/bash

while true; do
  state=$(hyprctl -j activewindow | jq '.fullscreen')
  if [ "$state" = "true" ]; then
    pkill -STOP waybar
    pkill -STOP nwg-dock-hyprland
  else
    pkill -CONT waybar
    pkill -CONT nwg-dock-hyprland
  fi
  sleep 1
done
