#!/bin/bash
VERSION=0.7.3

# Set the name of the model and its extension to be replaced
MODEL_NAME="model_name"
EXTENSION="ckpt"

# Set variables for easy updating
ROOT_DIR="/Volumes/External Drive/Stable Diffusion/ml-stable-diffusion-main"
WORK_DIR="/Volumes/External Drive/Stable Diffusion/ml-stable-diffusion-main/local_conversion/work"
MODELS_LOAD="/Volumes/External Drive - 14TB/Stable Diffusion/Model Archive"
COMPRESSED_DUMP="/Volumes/External Drive - 14TB/Stable Diffusion/HuggingFace Uploads"
DIFFUSERS_DUMP="${WORK_DIR}/Diffusers"
EM_PICKLES_DUMP="${WORK_DIR}/Embedded Pickles"
MODELS_LOCAL="${WORK_DIR}/${MODEL_NAME}"
MODELS_DUMP="${WORK_DIR}/Models"
VAE_LOAD="${WORK_DIR}/VAE"

# Define color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)
RESET=$(tput sgr 0)

echo -e "${BOLD}${CYAN}"
cat << "EOF"

 ▄▄·       ▄▄▄  ▄▄▄ .• ▌ ▄ ·. ▄▄▌  
▐█ ▌▪▪     ▀▄ █·▀▄.▀··██ ▐███▪██•  
██ ▄▄ ▄█▀▄ ▐▀▀▄ ▐▀▀▪▄▐█ ▌▐▌▐█·██▪  
▐███▌▐█▌.▐▌▐█•█▌▐█▄▄▌██ ██▌▐█▌▐█▌▐▌
·▀▀▀  ▀█▄▀▪.▀  ▀ ▀▀▀ ▀▀  █▪▀▀▀.▀▀▀ 

Script Selection                                       
EOF
echo "${RESET}${GREEN}Version${RESET}: ${YELLOW}${VERSION}${RESET}"
sleep 0.3

# Print message indicating activation of environment
echo "${RED}🚀 Activating Environment...🚀${RESET}"
sleep 0.2

# Navigate to the project directory and activate the virtual environment
cd "${ROOT_DIR}"
sleep 0.2
. bin/activate
sleep 0.2

# Navigate to the work directory
cd "${WORK_DIR}"
sleep 0.1

# Print message indicating successful activation of environment
echo "${GREEN}🎉 Environment Activated!${RESET}"
sleep 0.3

###################################################################

# Set a timer for the script to continue after 5 seconds
(sleep 3 && kill $! &>/dev/null) &

# Define a signal trap to catch SIGTERM and stop the script gracefully
trap 'printf "\033[1m\033[31mScript stopped by user.\033[0m\n"; (ps -p $! > /dev/null && kill $! &>/dev/null); exit 1' SIGTERM

###################################################################

# Print the variables name on the screen
echo "${RED}Current ROOT_DIR is:${RESET} ${GREEN}$ROOT_DIR${RESET}"
echo "${RED}Current WORK_DIR is:${RESET} ${GREEN}$WORK_DIR${RESET}"
echo "${RED}Current MODELS_LOAD is:${RESET} ${GREEN}$MODELS_LOAD${RESET}"
echo "${RED}Current COMPRESSED_DUMP is:${RESET} ${GREEN}$COMPRESSED_DUMP${RESET}"
echo "${RED}Current DIFFUSERS_DUMP is:${RESET} ${GREEN}$DIFFUSERS_DUMP${RESET}"
echo "${RED}Current MODELS_LOCAL is:${RESET} ${GREEN}$MODELS_LOCAL${RESET}"
echo "${RED}Current MODELS_DUMP is:${RESET} ${GREEN}$MODELS_DUMP${RESET}"
echo ""
sleep 0.3

# Print the current model name on the screen
echo "${RED}Current model name and extension is:${RESET} ${GREEN}$MODEL_NAME.$EXTENSION${RESET}"

echo ""
echo ""
sleep 0.2

#########################################################################

# Prompt the user for input to continue or stop the script
printf "\033[1m\033[31mMake sure all variables are updated! If they do not look correct use option 9 to update. Press any key to continue or 's' to stop the script\033[0m\n"
read -n 1 -s -r -t 3 response || (ps -p $! > /dev/null && kill $! &>/dev/null)

# If the user did not respond, continue the script
[[ "$response" == "s" ]] && exit 1

#########################################################################

# This script runs several conversion scripts for a particular model.

# Print a message indicating that the next script(s) will be run
echo ""
echo "${RED}Running next script(s)...${RESET}"
echo ""

# Pause for 3 seconds before running the scripts
sleep 0.3

# Prompt the user to select which conversion scripts to run
echo "Which conversion scripts would you like to run? (Enter space-separated numbers, e.g., 1 3 4)"
echo "1) Enable/Disable custom converison sizes and vae types - GUI"
echo "2) Enable/Disable custom converison sizes and vae types - terminal"
echo "3) Create diffusers from original source model file"
echo "4) Create custom VAE diffusers (also generates original source diffusers)"
echo "5) Convert & compile Original CoreML models from diffusers (512x512)"
echo "6) Convert & compile Original CoreML models from diffusers with custom sizes (see options 1 or 2)"
echo "7) Convert & compile Split einsum CoreML models from diffusers (512x512)"
echo "8) Compress files for sharing"
echo "9) Run #'s 3-8"
echo "10) Run the setup"
echo "11) Reload this script"
echo "12) Clear Diffusers folder"
echo "13) Reboot (Password needed)"
echo "14) Exit"
read -ra choices

# Check that the user input consists only of integers between 1 and 10
for choice in "${choices[@]}"; do
    if ! [[ "$choice" =~ ^(1|2|[3-9]|10|11|12|13|14)$ ]]; then
        echo "Invalid choice: $choice."
        exit 1
    fi
done

# Run the selected conversion scripts with lower priority (nice -n 10)
# Add option for model selector text version
for choice in "${choices[@]}"; do
    case $choice in
        1)  python ./conversion-script-model-selector.py ;;
        2)  python ./conversion-script-model-selector-text.py ;;
        3)  nice -n 10 "${WORK_DIR}/conversion-script.sh" ;;
        4)  nice -n 10 "${WORK_DIR}/conversion-script-VAE.sh" ;;
        5)  nice -n 10 "${WORK_DIR}/conversion-script-original.sh" ;;
        6)  nice -n 10 "${WORK_DIR}/conversion-script-original-cus-res.sh" ;;
        7)  nice -n 10 "${WORK_DIR}/conversion-script-split-einsum.sh" ;;
        8)  nice -n 10 "${WORK_DIR}/conversion-script-compress-prep.sh" ;;
        9)  nice -n 10 "${WORK_DIR}/conversion-script.sh"
            nice -n 10 "${WORK_DIR}/conversion-script-VAE.sh"
            nice -n 10 "${WORK_DIR}/conversion-script-original.sh"
            nice -n 10 "${WORK_DIR}/conversion-script-original-cus-res.sh"
            nice -n 10 "${WORK_DIR}/conversion-script-compress-prep.sh"
            nice -n 10 "${WORK_DIR}/conversion-script-split-einsum.sh"
            nice -n 10 "${WORK_DIR}/conversion-script-compress-prep.sh" ;;
		10)  nice -n 10 "${WORK_DIR}/conversion-script-setup.sh" ;;
        11) exec "$0";;
        12) rm -r ./Diffusers/* ;;
        13) sudo reboot ;;
        14) exit 1 ;;
    esac
done

exec "$0"