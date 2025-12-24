#!/bin/bash

echo "=========================================="
echo "Quick Workspace Setup"
echo "=========================================="

# Make scripts executable
chmod +x ~/.config/hypr/scripts/setup-workspaces.sh
chmod +x ~/.config/hypr/scripts/generate-workspace-keybinds.sh

# Generate configs
~/.config/hypr/scripts/setup-workspaces.sh
~/.config/hypr/scripts/generate-workspace-keybinds.sh

# Check files
echo ""
echo "Generated files:"
ls -la ~/.config/hypr/workspace-*.conf

echo ""
echo "✓ Setup complete!"
echo "Reload Hyprland: hyprctl reload"
