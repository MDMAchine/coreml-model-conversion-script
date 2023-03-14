#!/bin/bash
VERSION=0.7.6

# Set the name of the model and its extension to be replaced
MODEL_NAME="model_name"
EXTENSION="ckpt"

# Set variables for easy updating
ROOT_DIR="/ml-stable-diffusion-main"
WORK_DIR="/ml-stable-diffusion-main/work"
MODELS_LOAD="/Volumes/External Drive/Model Archive"
COMPRESSED_DUMP="/Volumes/External Drive/Uploads"
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
echo ""

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
echo ""

###################################################################

###################################################################

# Print the variables name on the screen
echo "${RED}Current ROOT_DIR is:${RESET}"
echo "${GREEN}$ROOT_DIR${RESET}"
echo "${RED}Current WORK_DIR is:${RESET}"
echo "${GREEN}$WORK_DIR${RESET}"
echo "${RED}Current MODELS_LOAD is:${RESET}"
echo "${GREEN}$MODELS_LOAD${RESET}"
echo "${RED}Current COMPRESSED_DUMP is:${RESET}"
echo "${GREEN}$COMPRESSED_DUMP${RESET}"
echo "${RED}Current DIFFUSERS_DUMP is:${RESET}"
echo "${GREEN}$DIFFUSERS_DUMP${RESET}"
echo "${RED}Current MODELS_LOCAL is:${RESET}"
echo "${GREEN}$MODELS_LOCAL${RESET}"
echo "${RED}Current MODELS_DUMP is:${RESET}"
echo "${GREEN}$MODELS_DUMP${RESET}"
echo ""
sleep 0.3

# Print the current model name on the screen
echo "${RED}Current model name and extension is:${RESET}"
echo "${GREEN}$MODEL_NAME.$EXTENSION${RESET}"

echo ""
echo ""
sleep 0.2

#########################################################################

#########################################################################

# This script runs several conversion scripts for a particular model.

# Pause for 3 seconds before running the scripts
sleep 0.3

# Prompt the user to select which conversion scripts to run
echo "${CYAN}Which conversion scripts would you like to run?${RESET}"
echo "	${YELLOW}(Enter space-separated numbers, e.g., 1 3 4)${RESET}"
echo ""
echo "${RED}1)${RESET}  Enable/Disable custom converison sizes and vae types - GUI"
echo "${RED}2)${RESET}  Enable/Disable custom converison sizes and vae types - terminal"
echo "${RED}3)${RESET}  Create diffusers from original source model file"
echo "${RED}4)${RESET}  Create custom VAE diffusers (also generates original source diffusers)"
echo "${RED}5)${RESET}  Convert & compile Original CoreML models from diffusers (512x512)"
echo "${RED}6)${RESET}  Convert & compile Original CoreML models from diffusers with custom sizes (see options 1 or 2)"
echo "${RED}7)${RESET}  Convert & compile Split einsum CoreML models from diffusers (512x512)"
echo "${RED}8)${RESET}  Compress files for sharing"
echo "${RED}9)${RESET}  Run #'s 3-8"
echo "${RED}10)${RESET} Set a new model name & extension"
echo "${RED}11)${RESET} Run the setup/update script"
echo "${RED}12)${RESET} Reload this script"
echo "${RED}13)${RESET} Clear Diffusers folder"
echo "${RED}14)${RESET} Run in low memory mode(s)"
echo "${RED}15)${RESET} Reboot (Password needed)"
echo "${RED}16)${RESET} Exit Script/low Mem Mode"
read -ra choices

# Check that the user input consists only of integers between 1 and 10
for choice in "${choices[@]}"; do
    if ! [[ "$choice" =~ ^(1|2|[3-9]|10|11|12|13|14|15|16)$ ]]; then
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
        3)  nice -n 10 "${WORK_DIR}/conversion-script-original-VAE.sh" ;;
        4)  nice -n 10 "${WORK_DIR}/conversion-script-custom-VAE.sh" ;;
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
		10) nice -n 10 "${WORK_DIR}/conversion-script-model-rename.sh" ;;
		11) nice -n 10 "${WORK_DIR}/conversion-script-setup.sh" ;;
        12) exec "$0" ;;
        13) rm -r ./Diffusers/* ;;
        14) nice -n 10 "${WORK_DIR}/conversion-script-memory-manager.sh" ;;
        15) sudo reboot ;;
        16) exit 1 ;;
    esac
done

exec "$0"