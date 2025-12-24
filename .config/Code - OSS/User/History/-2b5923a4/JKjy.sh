#!/bin/bash

# Lenovo portrait left (shifted slightly)
wlr-randr --output HDMI-A-1 --mode 1920x1080@74.949 --pos 1x1 --rotate 270

# Xiaomi ultrawide main right of Lenovo
wlr-randr --output DP-2 --mode 3440x1440@144 --pos 1081x1 --rotate normal
