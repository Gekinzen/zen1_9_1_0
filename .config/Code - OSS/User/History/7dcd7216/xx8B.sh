#!/bin/bash
# ---------------------------------------------------------------
# Reverse: 1999 Direct Launch Script for Arch Linux (Faugus + GE-Proton)
# ---------------------------------------------------------------
# Author: Paul's Setup
# Purpose: Run Reverse: 1999 directly (bypasses the launcher)
# Prefix:  /home/paul/Faugus/reverse-1999
# Proton:  GE-Proton (managed by Faugus)
# ---------------------------------------------------------------

# Optional performance environment variables
export DXVK_HUD=0
export WINEDEBUG=-all
export WINEDLLOVERRIDES="dxgi=n,b"

# Define key variables
FAUGUS_LOG='reverse-1999'
WINEPREFIX='/home/paul/Faugus/reverse-1999'
GAMEID='reverse-1999'
PROTONPATH='GE-Proton'
EXE_PATH="/home/paul/Faugus/reverse-1999/drive_c/Program Files (x86)/reverse1999_global/Reverse1999en"

# Launch the game directly through UMU (Faugus backend)
~/.local/share/faugus-launcher/umu-run "$EXE_PATH"
