#!/bin/bash

echo "=========================================="
echo "Fixing Login Lockout Settings"
echo "=========================================="

# Backup original config
sudo cp /etc/security/faillock.conf /etc/security/faillock.conf.bak

# Create new config with failure-based only
sudo tee /etc/security/faillock.conf > /dev/null << 'EOF'
# faillock configuration
# Only lock after failed attempts, no time-based lockout

# Deny access after 5 failed attempts
deny = 5

# Unlock time: 0 = never auto-unlock (must use faillock --reset)
# Set to 300 (5 minutes) if you want auto-unlock
unlock_time = 0

# Time window for counting failures (15 minutes)
fail_interval = 900

# Show number of failed attempts on login
even_deny_root
audit
silent

# Do NOT enable these (they cause timed lockouts):
# nodelay
# local_users_only
EOF

echo ""
echo "✓ Faillock configured:"
echo "  - Lock after 5 failed attempts"
echo "  - No automatic time-based lockout"
echo "  - Manual unlock: sudo faillock --user $USER --reset"
echo ""
echo "Current faillock status:"
faillock

echo ""
echo "If you're currently locked out, run:"
echo "  sudo faillock --user $USER --reset"
