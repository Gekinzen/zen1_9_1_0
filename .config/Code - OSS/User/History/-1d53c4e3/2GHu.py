#!/usr/bin/env python3

import json
import re
import os
from pathlib import Path

# Paths
home = Path.home()
monitor_config = home / ".config/hypr/workspace-monitors.conf"
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

# Read monitor configuration
monitors = {}
if monitor_config.exists():
    with open(monitor_config) as f:
        for line in f:
            if '=' in line and not line.strip().startswith('#'):
                key, value = line.strip().split('=', 1)
                monitors[key] = value
else:
    print("❌ No monitor config found!")
    exit(1)

primary = monitors.get('PRIMARY_MONITOR', '')
secondary = monitors.get('SECONDARY_MONITOR', '')

print(f"Primary: {primary}")
print(f"Secondary: {secondary}")

# Read Waybar config and strip comments
with open(waybar_config, 'r') as f:
    content = f.read()
    
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
        exit(1)

# Ensure hyprland/workspaces exists with proper config
if 'hyprland/workspaces' not in config:
    print("⚠️  Creating 'hyprland/workspaces' section")
    config['hyprland/workspaces'] = {
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

# Update persistent-workspaces
persistent = {primary: [1, 2, 3, 4, 5]}
if secondary:
    persistent[secondary] = [6, 7, 8, 9, 10]

config['hyprland/workspaces']['persistent-workspaces'] = persistent
print(f"✓ Updated persistent-workspaces: {persistent}")

# Make sure workspaces is in modules-left if not already
if 'modules-left' in config:
    modules_left = config['modules-left']
    if 'hyprland/workspaces' not in modules_left:
        config['modules-left'] = ['hyprland/workspaces'] + modules_left
        print("✓ Added workspaces to modules-left")
else:
    config['modules-left'] = ['hyprland/workspaces']
    print("✓ Created modules-left with workspaces")

# Backup original config
backup_path = waybar_config.with_suffix('.backup')
if not backup_path.exists():
    with open(waybar_config, 'r') as f_in:
        with open(backup_path, 'w') as f_out:
            f_out.write(f_in.read())
    print(f"✓ Backup created: {backup_path}")

# Write updated config
with open(waybar_config, 'w') as f:
    json.dump(config, f, indent=4)
    print(f"✓ Waybar config updated")

# Restart Waybar
os.system("killall waybar 2>/dev/null; sleep 0.5; waybar &")
print("✓ Waybar restarted")