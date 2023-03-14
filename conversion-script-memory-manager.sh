#!/bin/bash
VERSION=0.7.6

# Define color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)
RESET=$(tput sgr 0)

###################################################################
echo -e "${BOLD}${CYAN}"
cat << "EOF"

 ▄▄·       ▄▄▄  ▄▄▄ .• ▌ ▄ ·. ▄▄▌  
▐█ ▌▪▪     ▀▄ █·▀▄.▀··██ ▐███▪██•  
██ ▄▄ ▄█▀▄ ▐▀▀▄ ▐▀▀▪▄▐█ ▌▐▌▐█·██▪  
▐███▌▐█▌.▐▌▐█•█▌▐█▄▄▌██ ██▌▐█▌▐█▌▐▌
·▀▀▀  ▀█▄▀▪.▀  ▀ ▀▀▀ ▀▀  █▪▀▀▀.▀▀▀ 

Low Memory Mode Selection                                       
EOF
echo "${RESET}${GREEN}Version${RESET}: ${YELLOW}${VERSION}${RESET}"
sleep 0.3

# Set Perms
cd "$(dirname "${BASH_SOURCE[0]}")"
sleep 0.1
chmod 755 ./*
sleep 0.1

pip install Pillow

###################################################################

# Get user input
echo -e "\n${CYAN}Please select a mode:\n"
echo "  [1] Mode 1: python ./memory_manager_6.7-child_start.py (6.7 GB)"
echo "  [2] Mode 2: python ./memory_manager_80-child_start.py (80% of total)"
echo "  [3] Exit\n"
echo -n "${RESET}Enter your choice [1-3]: "

# Read user input with timeout
read -t 30 input

# Check user input
if [[ -n "$input" ]]; then
    case $input in
        1)
            echo -e "\n${GREEN}Mode 1 selected.${RESET}"
            python ./memory_manager_6.7-child_start.py
            ;;
        2)
            echo -e "\n${GREEN}Mode 2 selected.${RESET}"
            python ./memory_manager_80-child_start.py
            ;;
        3)
            echo -e "\n${YELLOW}Exiting...${RESET}"
            exit
            ;;
        *)
            echo -e "\n${RED}Invalid input.${RESET}"
            ;;
    esac
else
    echo -e "\n${YELLOW}No input received. Exiting...${RESET}"
fi

# Run the main conversion script
echo -e "\n${GREEN}Running the selection script.${RESET}"
./conversion-script-selector.sh
