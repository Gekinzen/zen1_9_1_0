#!/usr/bin/env bash

STATE_FILE="$HOME/.config/waybar/scripts/power_mode_state"

# Create state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    mkdir -p "$(dirname "$STATE_FILE")"
    echo "balanced" > "$STATE_FILE"
fi

# Read current mode
MODE=$(cat "$STATE_FILE")

# Function to apply CPU governor
apply_cpu_governor() {
    local governor=$1
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        [ -f "$cpu" ] && echo "$governor" | sudo tee "$cpu" > /dev/null 2>&1
    done
}

# Function to set AMD GPU performance
set_amd_gpu() {
    local mode=$1
    local gpu_path="/sys/class/drm/card0/device/power_dpm_force_performance_level"
    [ -f "$gpu_path" ] && echo "$mode" | sudo tee "$gpu_path" > /dev/null 2>&1
}

# Function to set Intel GPU power
set_intel_gpu() {
    local mode=$1
    local gt_path="/sys/class/drm/card0/gt_boost_freq_mhz"
    local max_path="/sys/class/drm/card0/gt_max_freq_mhz"
    local min_path="/sys/class/drm/card0/gt_min_freq_mhz"
    
    if [ -f "$max_path" ]; then
        case "$mode" in
            performance)
                cat "$max_path" | sudo tee "$gt_path" > /dev/null 2>&1
                cat "$max_path" | sudo tee "$min_path" > /dev/null 2>&1
                ;;
            battery)
                echo "300" | sudo tee "$min_path" > /dev/null 2>&1
                echo "800" | sudo tee "$gt_path" > /dev/null 2>&1
                ;;
            *)
                # Auto/balanced
                ;;
        esac
    fi
}

# Function to control turbo boost
set_turbo_boost() {
    local enable=$1
    # Intel
    [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ] && \
        echo "$enable" | sudo tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1
    # AMD
    [ -f /sys/devices/system/cpu/cpufreq/boost ] && \
        echo "$enable" | sudo tee /sys/devices/system/cpu/cpufreq/boost > /dev/null 2>&1
}

# Toggle to next mode with icons and colors
case "$MODE" in
    balanced)
        NEW="performance"
        MSG="Performance Mode"
        ICON="󱓞"
        APP_NAME="power-mode-performance"
        
        # Apply PERFORMANCE settings
        apply_cpu_governor "performance"
        set_amd_gpu "high"
        set_intel_gpu "performance"
        set_turbo_boost 0  # 0 = enable turbo (intel_pstate logic)
        
        # Set I/O scheduler to performance
        for disk in /sys/block/sd*/queue/scheduler; do
            [ -f "$disk" ] && echo "mq-deadline" | sudo tee "$disk" > /dev/null 2>&1
        done
        for disk in /sys/block/nvme*/queue/scheduler; do
            [ -f "$disk" ] && echo "none" | sudo tee "$disk" > /dev/null 2>&1
        done
        ;;
        
    performance)
        NEW="battery_saver"
        MSG="Battery Saver Mode"
        ICON="󰂃"
        APP_NAME="power-mode-battery"
        
        # Apply BATTERY SAVER settings
        apply_cpu_governor "powersave"
        set_amd_gpu "low"
        set_intel_gpu "battery"
        set_turbo_boost 1  # 1 = disable turbo
        
        # Set I/O scheduler to power-saving
        for disk in /sys/block/sd*/queue/scheduler; do
            [ -f "$disk" ] && echo "bfq" | sudo tee "$disk" > /dev/null 2>&1
        done
        for disk in /sys/block/nvme*/queue/scheduler; do
            [ -f "$disk" ] && echo "bfq" | sudo tee "$disk" > /dev/null 2>&1
        done
        ;;
        
    *)
        NEW="balanced"
        MSG="Balanced Mode"
        ICON="󰾅"
        APP_NAME="power-mode-balanced"
        
        # Apply BALANCED settings
        apply_cpu_governor "schedutil"
        set_amd_gpu "auto"
        set_intel_gpu "balanced"
        set_turbo_boost 0  # Enable turbo
        
        # Set I/O scheduler to balanced
        for disk in /sys/block/sd*/queue/scheduler; do
            [ -f "$disk" ] && echo "mq-deadline" | sudo tee "$disk" > /dev/null 2>&1
        done
        for disk in /sys/block/nvme*/queue/scheduler; do
            [ -f "$disk" ] && echo "none" | sudo tee "$disk" > /dev/null 2>&1
        done
        ;;
esac

# Save new mode
echo "$NEW" > "$STATE_FILE"

# Send styled notification using app-name for CSS targeting
notify-send "Power Mode" "$ICON $MSG Activated" -a "$APP_NAME"

# Signal waybar to refresh
pkill -SIGRTMIN+9 waybar

