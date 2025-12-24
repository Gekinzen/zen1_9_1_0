#!/bin/bash
set -e

echo "[Zen] Enabling services..."

systemctl enable bluetooth --now || true
systemctl --user enable pipewire pipewire-pulse --now || true

echo "[Zen] Services ready."
