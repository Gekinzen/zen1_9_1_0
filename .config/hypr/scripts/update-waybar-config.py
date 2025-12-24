#!/usr/bin/env python3

import json
import re
import os
from pathlib import Path

# Paths
home = Path.home()
waybar_dir = home / ".config/waybar"

# Find waybar config file
waybar_config = None
for config_name in ['config.jsonc', 'config.json', 'config']:
    potential_path = waybar_dir / config_name
    if potential_path.exists():
        waybar_config = potential_path
        break

if not waybar_config:
    print("❌ No Waybar config found!")
    exit(1)

print(f"Found Waybar config: {waybar_config}")

# Read Waybar config and strip comments
with open(waybar_config, 'r') as f:
    content = f.read()
    original_content = content  # Keep original for backup
    
    # Remove single-line comments (// ...)
    content = re.sub(r'//.*?\n', '\n', content)
    
    # Remove multi-line comments (/* ... */)
    content = re.sub(r'/\*.*?\*/', '', content, flags=re.DOTALL)
    
    # Remove trailing commas before closing braces/brackets
    content = re.sub(r',(\s*[}\]])', r'\1', content)
    
    try:
        config = json.loads(content)
    except json.JSONDecodeError as e:
        print(f"❌ Error parsing JSON: {e}")
        print("Restoring from backup...")
        exit(1)

# Ensure hyprland/workspaces exists with proper config
if 'hyprland/workspaces' not in config:
    print("⚠️  Creating 'hyprland/workspaces' section")
    config['hyprland/workspaces'] = {}

# Set dynamic workspace config
workspace_config = {
    "active-only": False,
    "all-outputs": False,
    "show-special": False,
    "on-click": "activate",
    "format": "{icon}",
    "on-scroll-up": "hyprctl dispatch workspace m+1",
    "on-scroll-down": "hyprctl dispatch workspace m-1",
    "format-icons": {
        "active": "",
        "default": "",
        "empty": ""
    }
}

# Update workspace config
config['hyprland/workspaces'].update(workspace_config)

# REMOVE persistent-workspaces if it exists (for dynamic behavior)
if 'persistent-workspaces' in config['hyprland/workspaces']:
    del config['hyprland/workspaces']['persistent-workspaces']
    print("✓ Removed persistent-workspaces for fully dynamic behavior")

print(f"✓ Updated to dynamic workspaces")

# Make sure workspaces module is in modules list
modules_updated = False
if 'modules-left' in config:
    if 'hyprland/workspaces' not in config['modules-left']:
        # Only add if not in any modules
        if ('modules-center' not in config or 'hyprland/workspaces' not in config.get('modules-center', [])):
            config['modules-left'].insert(0, 'hyprland/workspaces')
            modules_updated = True
            print("✓ Added workspaces to modules-left")

if 'modules-center' in config:
    if 'hyprland/workspaces' not in config['modules-center']:
        if not modules_updated:
            # Check if it's in left, if not add to center
            if 'hyprland/workspaces' not in config.get('modules-left', []):
                config['modules-center'].insert(0, 'hyprland/workspaces')
                print("✓ Added workspaces to modules-center")

# Backup original config
backup_path = waybar_config.with_suffix('.backup')
if not backup_path.exists():
    with open(backup_path, 'w') as f_out:
        f_out.write(original_content)
    print(f"✓ Backup created: {backup_path}")

# Write updated config
with open(waybar_config, 'w') as f:
    json.dump(config, f, indent=4)
    print(f"✓ Waybar config updated")

# Restart Waybar
os.system("killall waybar 2>/dev/null; sleep 0.5; waybar &")
print("✓ Waybar restarted")