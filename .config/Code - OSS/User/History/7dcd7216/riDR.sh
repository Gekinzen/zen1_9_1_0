#!/bin/bash
# Reverse: 1999 launcher bypass for Faugus (Pop!_OS)

# --- Wine/Proton Environment ---
export WINEPREFIX="/home/paul/Faugus/reverse-1999"
export WINEESYNC=1
export WINEFSYNC=1
export DXVK_ASYNC=1
export DXVK_HUD=0                # set to 1 if you want fps overlay
export PROTON_NO_ESYNC=0
export PROTON_NO_FSYNC=0
export PROTON_LOG=1              # creates a log file if crash happens

# Optional fix for white/black cutscenes (DXVK d3d11 mode tweak)
export DXVK_USE_PIPECOMPILER=1
export DXVK_STATE_CACHE=1
export DXVK_STATE_CACHE_PATH="$WINEPREFIX/dxvk-cache"
export VKD3D_CONFIG=dxr11
export VKD3D_FEATURE_LEVEL=12_1

# --- Game Launch Path ---
cd "$WINEPREFIX/drive_c/Program Files (x86)/reverse1999_global/Reverse1999en"

# Run the game executable directly (bypasses launcher)
wine reverse1999.exe
