#!/bin/bash
VERSION=0.7.6

# Define color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)
RESET=$(tput sgr0)

###################################################################
echo -e "${BOLD}${YELLOW}"
cat << "EOF"
##############################################################
EOF
echo -e "${BOLD}${RED}"
cat << "EOF"
CONVERSION SCRIPT BY:
 _______ _____  _______ _______        __     __              
|   |   |     \|   |   |   _   |.----.|  |--.|__|.-----.-----.
|       |  --  |       |       ||  __||     ||  ||     |  -__|
|__|_|__|_____/|__|_|__|___|___||____||__|__||__||__|__|_____|
EOF
echo -e "${BOLD}${YELLOW}"
cat << "EOF"
##############################################################
EOF
echo "${RESET}${GREEN}Version${RESET}: ${YELLOW}${VERSION}${RESET}"
echo ""
sleep 0.5

# Set Perms
cd "$(dirname "${BASH_SOURCE[0]}")"
sleep 0.1
chmod 755 ./*
sleep 0.1

###################################################################

# Print welcome message
echo "${GREEN}Welcome to the CoreML conversion script loader!${RESET}"
echo "${CYAN}Please select a script to load:${RESET}"

# Define script options
options=("Full Setup" "Script Selector" "Quit")

# Loop until the user quits
while true; do
    # Print script options
    for i in "${!options[@]}"; do
        echo "${YELLOW}$((i+1)). ${options[i]}${RESET}"
    done

    # Prompt the user for input
    read -p "Enter a number: " choice

    # Check if the user chose to quit
    if [[ $choice -eq ${#options[@]} ]]; then
        echo "${CYAN}Goodbye!${RESET}"
        exit
    fi

    # Check if the user entered a valid option
    if [[ $choice -gt 0 && $choice -le ${#options[@]} ]]; then
        # Load the selected script
        case $choice in
            1)
                echo "${CYAN}Loading Full Setup...${RESET}"
                nice -n 10 "./conversion-script-setup.sh"
                ;;
            2)
                echo "${CYAN}Loading Script Selector...${RESET}"
                nice -n 10 "./conversion-script-selector.sh"
                ;;
        esac
        break
    else
        # Invalid option
        echo "${RED}Invalid option. Please try again.${RESET}"
    fi
done
