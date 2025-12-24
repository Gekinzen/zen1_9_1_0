#!/bin/bash

SCRIPT_DIR="$HOME/.config/hypr/scripts/py"
SCRIPT="$SCRIPT_DIR/control-center.py"

# ensure script exists
if [ ! -f "$SCRIPT" ]; then
  notify-send "Hypr Control" "control-center.py not found!"
  exit 1
fi

setsid -f python "$SCRIPT"
