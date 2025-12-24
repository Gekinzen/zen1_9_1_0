#!/bin/bash

# Create temporary HTML file for system settings widget
TMP_HTML="/tmp/swaync-system-settings.html"

cat > "$TMP_HTML" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <style>
        body {
            background: transparent;
            color: #c0caf5;
            font-family: 'CodeNewRoman Nerd Font';
            padding: 10px;
            margin: 0;
        }
        .settings-item {
            padding: 15px 20px;
            margin: 8px 0;
            background: rgba(122, 162, 247, 0.15);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s;
            border: 1px solid rgba(122, 162, 247, 0.2);
        }
        .settings-item:hover {
            background: rgba(122, 162, 247, 0.3);
            border-color: rgba(122, 162, 247, 0.5);
        }
        .icon {
            display: inline-block;
            width: 30px;
        }
    </style>
</head>
<body>
    <div class="settings-item" onclick="exec('appearance')">
        <span class="icon">󰏘</span> Appearance
    </div>
    <div class="settings-item" onclick="exec('system')">
        <span class="icon">󰒓</span> System
    </div>
    <div class="settings-item" onclick="exec('desktop')">
        <span class="icon">󰍹</span> Desktop
    </div>
    <div class="settings-item" onclick="exec('keybindings')">
        <span class="icon">󰌌</span> Keybindings
    </div>
</body>
</html>
EOF

# Show as notification (won't work with HTML, so use a different approach)