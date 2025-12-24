#!/bin/bash
source ~/.cache/wal/colors.sh

cat > ~/.config/nwg-dock-hyprland/style.css <<EOF
window {
  background-color: ${background}cc;
  border-radius: 12px;
}
button {
  color: ${foreground};
}
EOF

pkill -f nwg-dock-hyprland
~/.config/hypr/scripts/dock-manager.sh
EOF
chmod +x ~/.config/hypr/scripts/update-dock-colors.sh

