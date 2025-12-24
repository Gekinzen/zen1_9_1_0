#!/bin/bash
export WINEPREFIX="/home/paul/Faugus/reverse-1999"
export WINEESYNC=1
export WINEFSYNC=1
export DXVK_ASYNC=1

# Optional Proton tweaks (you can comment out if not needed)
export PROTON_NO_ESYNC=0
export PROTON_NO_FSYNC=0

# Change directory to the game folder
cd "$WINEPREFIX/drive_c/Program Files (x86)/reverse1999_global/Reverse1999en"

# Run the actual game executable
wine reverse1999.exe
