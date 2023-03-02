#!/bin/bash
# Script By:
#       _____        _____         _____        _____                                             
#   ___|    _|__  __|__   |__  ___|    _|__  __|_    |__  ______  __   _  ____  ____   _  ______  
#  |    \  /  | ||     \     ||    \  /  | ||    \      ||   ___||  |_| ||    ||    \ | ||   ___| 
#  |     \/   | ||      \    ||     \/   | ||     \     ||   |__ |   _  ||    ||     \| ||   ___| 
#  |__/\__/|__|_||______/  __||__/\__/|__|_||__|\__\  __||______||__| |_||____||__/\____||______| 
#      |_____|      |_____|       |_____|      |_____|                                            
#
#################################################################################################

# Set the name of the model to be replaced
MODEL_NAME="changeme"

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

CONVERSION SCRIPT - DIFF
EOF
echo -e "${RESET}${YELLOW}Version 06${RESET}"
sleep 0.5

# Print message indicating activation of environment
echo "${RED}🚀 Activating Environment...🚀${RESET}"
sleep 0.2

# Navigate to the project directory and activate the virtual environment
cd "${ROOT_DIR}"
sleep 0.3
. bin/activate
sleep 0.2

# Navigate to the work directory
cd "${WORK_DIR}"
sleep 0.2

# Print message indicating successful activation of environment
echo "${GREEN}🎉 Environment Activated!${RESET}"
sleep 0.5

####################################################################
## Edited to remove the 15 second timer (its on selector script now)
#
## Print the variables name on the screen
#echo "${RED}Current ROOT_DIR is:${RESET} ${GREEN}$ROOT_DIR${RESET}"
#echo "${RED}Current WORK_DIR is:${RESET} ${GREEN}$WORK_DIR${RESET}"
#echo "${RED}Current MODELS_LOAD is:${RESET} ${GREEN}$MODELS_LOAD${RESET}"
#echo "${RED}Current COMPRESSED_DUMP is:${RESET} ${GREEN}$COMPRESSED_DUMP${RESET}"
#echo "${RED}Current DIFFUSERS_DUMP is:${RESET} ${GREEN}$DIFFUSERS_DUMP${RESET}"
#echo "${RED}Current MODELS_LOCAL is:${RESET} ${GREEN}$MODELS_LOCAL${RESET}"
#echo "${RED}Current MODELS_DUMP is:${RESET} ${GREEN}$MODELS_DUMP${RESET}"
#echo ""
#sleep 0.3
#
## Print the current model name on the screen
#echo "${RED}Current model name is:${RESET} ${GREEN}$MODEL_NAME${RESET}"
#sleep 1
#echo ""
#
##########################################################################

# Copy workfile to working directory
echo ""
echo "${RED}Copying workfile to working directory ${RESET}"
echo ""
sleep 0.3

# Check if file exists before copying
if [ -f "${WORK_DIR}/${MODEL_NAME}.ckpt" ]; then
  echo ""
  echo "${YELLOW}File already exists in working directory. Skipping copy.${RESET}"
  echo ""
else
  start=$SECONDS
  cp -v "${MODELS_LOAD}/${MODEL_NAME}.ckpt" "${WORK_DIR}"
  end=$SECONDS
  duration=$(( end - start ))
  echo ""
  echo "${GREEN}Copy took $duration seconds to complete${RESET}"
  echo ""
  sleep 0.3
fi

# Change directory to Stable Diffusion project
cd "${ROOT_DIR}"

start=$SECONDS

# Function to create diffusers from a specified checkpoint path and dump path
function create_diffusers() {
  local checkpoint_path="$1"
  local dump_path="$2"
  local attempts=3

  # Check if dump path exists, skip creation if it does
  if [[ -d "${dump_path}" ]]; then
    echo "${YELLOW}Skipping diffuser creation, path already exists: ${dump_path}${RESET}"
    return
  fi

  # Try creating diffusers with given checkpoint path and dump path up to 20 times
  for ((i=1; i<=$attempts; i++)); do
    if python convert_original_stable_diffusion_to_diffusers.py --checkpoint_path "${checkpoint_path}" --device cpu --extract_ema --dump_path "${dump_path}"; then
      echo "${GREEN}The conversion of the workfile into diffusers is complete${RESET}"
      echo ""
      return
    else
      echo "${CYAN}Conversion killed with exit code $?. Respawning...${RESET}" >&2
      echo "${YELLOW}Retrying #$i out of $attempts...${RESET}"
      sleep 0.3
    fi
  done

  # If creation failed too many times, skip and print message
  echo "${RED}Skipping after too many attempts${RESET}"
}

# Create diffusers from raw workfile
echo "${RED}Now creating diffusers from the raw workfile into diffusers...${RESET}"
create_diffusers "${MODELS_LOCAL}.ckpt" "${DIFFUSERS_DUMP}/${MODEL_NAME}_raw_diffusers_model/"

# Print the duration of the diffuser creation process
duration=$(( SECONDS - start ))
echo "${GREEN}The conversion of diffusers took $duration seconds to complete${RESET}"

# Clean up message
echo ""
echo "${RED}Cleaning Up!${RESET}"
echo ""
sleep 0.3

# Navigate to the work directory
cd "${WORK_DIR}"
sleep 0.3

# Check if workfile exists
if [[ ! -f "${WORK_DIR}/${MODEL_NAME}.ckpt" ]]; then
  echo "Workfile does not exist, skipping deletion."
  exit 0
fi

# Ask user if they want to delete the workfile
read -rp "Do you want to delete the workfile? Otherwise it will be automatically removed after 15 seconds. [y/N]: " -t 15 userInput

if [[ -z "${userInput}" ]]; then
  # User didn't respond in time
  echo "Automatically removed workfile after 15 seconds."
  if rm "${WORK_DIR}/${MODEL_NAME}.ckpt"; then
    echo "Successfully deleted workfile"
  else
    echo "Error: Failed to delete workfile"
  fi
elif [[ "${userInput}" =~ ^[Yy]$ ]]; then
  # Delete workfile
  if rm "${WORK_DIR}/${MODEL_NAME}.ckpt"; then
    echo "Successfully deleted workfile"
  else
    echo "Error: Failed to delete workfile"
  fi
else
  echo "Skipping deletion of workfile."
fi

sleep 0.3

# Done message
echo ""
echo "${GREEN}Done!${RESET}"