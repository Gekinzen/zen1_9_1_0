#!/bin/bash
set -e

echo "[Zen] Installing base system..."

yay -S --needed \
  rofi wofi \
  waybar swaync swww \
  hypridle hyprlock hyprshot hyprpicker \
  pyprland \
  pipewire pipewire-pulse pipewire-alsa pipewire-jack \
  brightnessctl pavucontrol \
  thunar gvfs tumbler \
  neovim git fd eza htop bottom \
  nerd-fonts nwg-look


echo "[Zen] Base system installed."
