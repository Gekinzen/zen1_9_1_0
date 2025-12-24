#!/bin/bash

# Zen Terminal Fetch
# Custom fetch script with Zen aesthetics

# Colors (Everforest palette)
FOREST_GREEN="\033[38;5;108m"    # #798171
ACCENT_ORANGE="\033[38;5;203m"   # #E1664E
SOFT_YELLOW="\033[38;5;180m"     # #DBBC7F
SAGE_GREEN="\033[38;5;108m"      # #A7C080
SKY_BLUE="\033[38;5;109m"        # #7FBBB3
SOFT_PINK="\033[38;5;175m"       # #D699B6
RESET="\033[0m"
BOLD="\033[1m"
DIM="\033[2m"

# Zen Logo (minimalist design)
print_logo() {
    echo -e "${FOREST_GREEN}"
    cat << "EOF"
            ╔════════════════════════════╗
            ║                            ║
            ║     ███████╗███████╗███╗   ║
            ║     ╚══███╔╝██╔════╝████╗  ║
            ║       ███╔╝ █████╗  ██╔██╗ ║
            ║      ███╔╝  ██╔══╝  ██║╚██╗║
            ║     ███████╗███████╗██║ ╚██║
            ║     ╚══════╝╚══════╝╚═╝  ╚═║
            ║                            ║
            ╚════════════════════════════╝
EOF
    echo -e "${RESET}"
}

# Alternative minimalist logo
print_minimal_logo() {
    echo -e "${FOREST_GREEN}"
    cat << "EOF"
                ▞▀▖     
                ▚▄▘▛▀▖▛▀▖
                ▖ ▌▌ ▌▌ ▌
                ▝▀ ▀▀ ▘ ▘
EOF
    echo -e "${RESET}"
}

# Get system info
get_os() {
    echo "Arch Linux"
}

get_kernel() {
    uname -r
}

get_uptime() {
    uptime -p | sed 's/up //'
}

get_packages() {
    pacman -Qq | wc -l
}

get_shell() {
    basename "$SHELL"
}

get_wm() {
    echo "Hyprland"
}

get_terminal() {
    echo "Kitty"
}

get_cpu() {
    grep "model name" /proc/cpuinfo | head -n1 | cut -d':' -f2 | sed 's/^[ \t]*//' | cut -d'@' -f1
}

get_memory() {
    free -h | awk '/^Mem:/ {print $3 " / " $2}'
}

# Print system info
print_info() {
    local label_color="${SAGE_GREEN}"
    local value_color="${SOFT_YELLOW}"
    local separator="${DIM}${FOREST_GREEN}───${RESET}"
    
    echo -e "\n"
    echo -e "  ${separator}"
    echo -e "  ${ACCENT_ORANGE}${BOLD}ZEN${RESET} ${DIM}Terminal Environment${RESET}"
    echo -e "  ${separator}\n"
    
    echo -e "  ${label_color}${BOLD}Version${RESET}     ${value_color}Alpha 1.7.1${RESET}"
    echo -e "  ${label_color}${BOLD}Base${RESET}        ${value_color}Arch Linux${RESET}"
    echo -e "  ${label_color}${BOLD}Developer${RESET}   ${value_color}Zenkiyu${RESET}"
    echo -e ""
    echo -e "  ${separator}\n"
    
    echo -e "  ${SKY_BLUE}󰌽  ${label_color}OS${RESET}          ${value_color}$(get_os)${RESET}"
    echo -e "  ${SKY_BLUE}  ${label_color}Kernel${RESET}      ${value_color}$(get_kernel)${RESET}"
    echo -e "  ${SKY_BLUE}  ${label_color}Uptime${RESET}      ${value_color}$(get_uptime)${RESET}"
    echo -e "  ${SKY_BLUE}󰏖  ${label_color}Packages${RESET}    ${value_color}$(get_packages)${RESET}"
    echo -e "  ${SKY_BLUE}  ${label_color}Shell${RESET}       ${value_color}$(get_shell)${RESET}"
    echo -e "  ${SKY_BLUE}  ${label_color}WM${RESET}          ${value_color}$(get_wm)${RESET}"
    echo -e "  ${SKY_BLUE}  ${label_color}Terminal${RESET}    ${value_color}$(get_terminal)${RESET}"
    echo -e "  ${SKY_BLUE}󰍛  ${label_color}CPU${RESET}         ${value_color}$(get_cpu)${RESET}"
    echo -e "  ${SKY_BLUE}󰑭  ${label_color}Memory${RESET}      ${value_color}$(get_memory)${RESET}"
    
    echo -e "\n  ${separator}\n"
}

# Print color palette
print_colors() {
    echo -e "  ${FOREST_GREEN}●${RESET} ${ACCENT_ORANGE}●${RESET} ${SOFT_YELLOW}●${RESET} ${SAGE_GREEN}●${RESET} ${SKY_BLUE}●${RESET} ${SOFT_PINK}●${RESET}\n"
}

# Main execution
clear
print_minimal_logo
print_info
print_colors

# Optional: Add a zen quote
echo -e "  ${DIM}${FOREST_GREEN}\"Simplicity is the ultimate sophistication\"${RESET}\n"