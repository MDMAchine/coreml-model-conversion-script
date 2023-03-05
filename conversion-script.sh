#!/bin/bash

# Set the name of the model and its extension to be replaced
MODEL_NAME="modelname"
EXTENSION="safetensors"

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
echo -e "${RESET}${YELLOW}Version 07${RESET}"
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

# Copy workfile to working directory
echo ""
echo "${RED}Copying workfile to working directory ${RESET}"
echo ""
sleep 0.3

# Check if file exists before copying
if [ -f "${WORK_DIR}/${MODEL_NAME}.${EXTENSION}" ]; then
  echo ""
  echo "${YELLOW}File already exists in working directory. Skipping copy.${RESET}"
  echo ""
else
  start=$SECONDS
  cp -v "${MODELS_LOAD}/${MODEL_NAME}.${EXTENSION}" "${WORK_DIR}"
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
	local from_safetensors_arg=""
	
	# Check for is the extension safetensors is set for argument setting
	if [ "$EXTENSION" = "safetensors" ]; then
        from_safetensors_arg="--from_safetensors"
    fi

	# Check if dump path exists, skip creation if it does
	if [[ -d "${dump_path}" ]]; then
    echo "${YELLOW}Skipping diffuser creation, path already exists: ${dump_path}${RESET}"
    return
	fi

	# Try creating diffusers with given checkpoint path and dump path up to 20 times
	for ((i=1; i<=$attempts; i++)); do
    if python convert_original_stable_diffusion_to_diffusers.py --checkpoint_path "${checkpoint_path}" --device cpu --extract_ema --dump_path "${dump_path}" --upcast_attention $from_safetensors_arg; then
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
create_diffusers "${MODELS_LOCAL}.${EXTENSION}" "${DIFFUSERS_DUMP}/${MODEL_NAME}_raw_diffusers_model/"

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
if [[ ! -f "${WORK_DIR}/${MODEL_NAME}.${EXTENSION}" ]]; then
  echo "Workfile does not exist, skipping deletion."
  exit 0
fi

# Ask user if they want to delete the workfile
read -rp "Do you want to delete the workfile? Otherwise it will be automatically removed after 15 seconds. [y/N]: " -t 15 userInput

if [[ -z "${userInput}" ]]; then
  # User didn't respond in time
  echo "Automatically removed workfile after 15 seconds."
  if rm "${WORK_DIR}/${MODEL_NAME}.${EXTENSION}"; then
    echo "Successfully deleted workfile"
  else
    echo "Error: Failed to delete workfile"
  fi
elif [[ "${userInput}" =~ ^[Yy]$ ]]; then
  # Delete workfile
  if rm "${WORK_DIR}/${MODEL_NAME}.${EXTENSION}"; then
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
echo ""