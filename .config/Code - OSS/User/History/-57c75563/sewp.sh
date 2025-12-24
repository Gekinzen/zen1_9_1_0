#!/bin/bash

pkill rofi 2>/dev/null

rofi -show drun \
    -show-icons \
    -icon-theme "Papirus-Dark" \
    -display-drun "Applications"