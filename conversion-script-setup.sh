#!/bin/bash
VERSION=0.7.3

# Set the name of the model and its extension to be replaced
MODEL_NAME="experience-V7"
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

# Change the working directory to the script directory
cd "$(dirname "${BASH_SOURCE[0]}")"

# Prompt user to update variables
#read -t 15 -p "Do you want to update the variables? (y/n) " answer
read -p "Do you want to update the variables? (y/n) " answer

if [[ "$answer" =~ ^[yY]$ ]]; then
	echo ${GREEN}Making a backup zip in /backups${RESET}
	sleep 0.3
    # Define the number of backups to keep
    MAX_BACKUPS=3

    # Get the current directory name
    DIR_NAME="$(basename "$(pwd)")"

    # Create the backup directory if it doesn't already exist
    if [ ! -d "backups" ]; then
        mkdir backups
    fi

    # Remove old backups if necessary
    while [ "$(ls backups | wc -l)" -ge "$MAX_BACKUPS" ]; do
        rm -rf "backups/$(ls backups | head -n 1)"
    done

    # Create the backup file
	BACKUP_NAME="$DIR_NAME-$(date '+%Y-%m-%d-%H-%M-%S').zip"
	find . -maxdepth 1 -type f ! -name '*.'$EXTENSION ! -name '.*' ! -path './Archive/*' ! -path './Diffusers/*' ! -path './Embedded Pickles/*' ! -path './links/*' ! -path './misc/*' ! -path './Models/*' ! -path './other scripts/*' ! -path './Safe-and-Stable-Ckpt2Safetensors-Conversion-Tool-GUI/*' ! -path './test scripts/*' ! -path './VAE/*' ! -path './yaml/*' -exec zip -r "backups/$BACKUP_NAME" {} +

    # Execute command if user chooses to update variables
    echo -e "${GREEN}Updating variables${RESET}"
    nice -n 10 ./conversion-script-variables.sh
    exec "$0"
else
    echo -e "${YELLOW}Skipping variable update${RESET}"
fi

echo ""
echo ""
sleep 0.2

#########################################################################


# Prompt the user to update the model name and extension
read -p "Do you want to update the model filename and extension? (y/n) " answer
if [[ "$answer" =~ ^[yY]$ ]]; then
    echo -e "${GREEN}Making a backup zip in /backups${RESET}"
    sleep 0.3
    # Define the number of backups to keep
    MAX_BACKUPS=3

    # Get the current directory name
    DIR_NAME="$(basename "$(pwd)")"

    # Create the backup directory if it doesn't already exist
    if [ ! -d "backups" ]; then
        mkdir backups
    fi

    # Remove old backups if necessary
    while [ "$(ls backups | wc -l)" -ge "$MAX_BACKUPS" ]; do
        rm -rf "backups/$(ls backups | head -n 1)"
    done

    # Create the backup file
	BACKUP_NAME="$DIR_NAME-$(date '+%Y-%m-%d-%H-%M-%S').zip"
	find . -maxdepth 1 -type f ! -name '*.'$EXTENSION ! -name '.*' ! -path './Archive/*' ! -path './Diffusers/*' ! -path './Embedded Pickles/*' ! -path './links/*' ! -path './misc/*' ! -path './Models/*' ! -path './other scripts/*' ! -path './Safe-and-Stable-Ckpt2Safetensors-Conversion-Tool-GUI/*' ! -path './test scripts/*' ! -path './VAE/*' ! -path './yaml/*' -exec zip -r "backups/$BACKUP_NAME" {} +

    # Prompt the user for input
    read -p "Enter new model name: " input_name
    read -p "Enter new file extension: " input_ext

    # Update MODEL_NAME and EXTENSION in files containing 'conversion-script'
    export LANG=C # Set the LANG environment variable to C
	find . -type f -name "*conversion-script*" ! -path "./backups/*" -exec sed -i '' "s/MODEL_NAME=\".*\"/MODEL_NAME=\"$input_name\"/" {} \;
    find . -type f -name "*conversion-script*" ! -path "./backups/*" -exec sed -i '' "s/EXTENSION=\".*\"/EXTENSION=\"$input_ext\"/" {} \;

    echo -e "${GREEN}Model name and extension updated${RESET}"
else
    echo -e "${YELLOW}Skipping model name and extension update${RESET}"
fi

echo ""
echo ""
sleep 0.2

###################################################################

echo "${CYAN}Option to update requirements via pip, place 'convert_original_stable_diffusion_to_diffusers.py' & 'torch2coreml_fp32.py' into root:${RESET}"
echo ""
echo ""
sleep 0.2

# ask if the user wants to update diffusers and safetensors
read -t 10 -p "${RED}Do you want to install/update stuff related to the scripts?${RESET} (y/n) ${YELLOW}Skipping in 10 seconds.${RESET} " update_diffusers_safetensors

# if there is no input in 3 seconds, continue on
if [ -z "$update_diffusers_safetensors" ]; then
  echo "${RED}No input received. Skipping update of diffusers and safetensors.${RESET}"
else
  if [ "$update_diffusers_safetensors" == "y" ]; then
    pip install --upgrade diffusers transformers accelerate safetensors omegaconf torch coremltools scipy
    cd "${ROOT_DIR}"
	pip install -e .
	cd "${WORK_DIR}"
	#pip install diffusers[torch]
  else
    echo "${RED}Skipping update of diffusers and safetensors.${RESET}"
  fi
fi

echo ""
echo ""
sleep 0.2

# ask if the user wants to update/place convert_original_stable_diffusion_to_diffusers.py
read -t 10 -p "${RED}Do you want to update 'convert_original_stable_diffusion_to_diffusers.py'?${RESET} (y/n) ${YELLOW}Skipping in 10 seconds.${RESET} " update_convert_script

# if there is no input in 3 seconds, continue on
if [ -z "$update_convert_script" ]; then
  echo "${RED}No input received. Skipping update of 'convert_original_stable_diffusion_to_diffusers.py'.${RESET}"
else
  if [ "$update_convert_script" == "y" ]; then
    # backup the old script with a max limit of 3
    for i in $(seq 2 -1 0); do
      if [ -f "${ROOT_DIR}/convert_original_stable_diffusion_to_diffusers_${i}.py" ]; then
        mv "${ROOT_DIR}/convert_original_stable_diffusion_to_diffusers_${i}.py" "${ROOT_DIR}/convert_original_stable_diffusion_to_diffusers_$((i+1)).py"
      fi
    done
    if [ -f "${ROOT_DIR}/convert_original_stable_diffusion_to_diffusers.py" ]; then
      mv "${ROOT_DIR}/convert_original_stable_diffusion_to_diffusers.py" "${ROOT_DIR}/convert_original_stable_diffusion_to_diffusers_1.py"
    fi

    # download the new script
    curl -o "${ROOT_DIR}/convert_original_stable_diffusion_to_diffusers.py" https://raw.githubusercontent.com/huggingface/diffusers/8dfff7c01529a1a476696691626b261f92fd19e3/scripts/convert_original_stable_diffusion_to_diffusers.py
  else
    echo "${RED}Skipping update of 'convert_original_stable_diffusion_to_diffusers.py'.${RESET}"
  fi
fi

echo ""
echo ""
sleep 0.2

# ask if the user wants to update download torch2coreml_fp32.py?
read -t 10 -p "${RED}Do you want to download 'torch2coreml_fp32.py'? Thisis required for creating 32 bit models!${RESET} (y/n) ${YELLOW}Skipping in 10 seconds.${RESET} " high_convert_script

# if there is no input in 3 seconds, continue on
if [ -z "$high_convert_script" ]; then
  echo "${RED}No input received. Skipping update of 'torch2coreml_fp32.py'.${RESET}"
else
  if [ "$high_convert_script" == "y" ]; then
    # backup the old script with a max limit of 3
    for i in $(seq 2 -1 0); do
      if [ -f "${ROOT_DIR}/python_coreml_stable_diffusion/torch2coreml_fp32_${i}.py" ]; then
        mv "${ROOT_DIR}/python_coreml_stable_diffusion/torch2coreml_fp32_${i}.py" "${ROOT_DIR}/python_coreml_stable_diffusion/torch2coreml_fp32_$((i+1)).py"
      fi
    done
    if [ -f "${ROOT_DIR}/python_coreml_stable_diffusion/torch2coreml_fp32.py" ]; then
      mv "${ROOT_DIR}/python_coreml_stable_diffusion/torch2coreml_fp32.py" "${ROOT_DIR}/python_coreml_stable_diffusion/torch2coreml_fp32.py"
    fi

    # download the new script
    curl -o "${ROOT_DIR}/python_coreml_stable_diffusion/torch2coreml_fp32.py" https://raw.githubusercontent.com/MDMAchine/coreml-model-conversion-script/main/misc/torch2coreml_fp32.py
  else
    echo "${RED}Skipping update of 'torch2coreml_fp32.py'.${RESET}"
  fi
fi


echo ""
echo ""
sleep 0.2

###################################################################

# Define variables
FOLDERS=("Diffusers" "Models" "VAE")
TIMER=3

# Check if folders exist and create them if they don't, or print a message if they do
for folder in "${FOLDERS[@]}"; do
  if [ -d "$folder" ]; then
    echo "Folder already exists: $folder"
  else
    mkdir "$folder" && echo "Created folder: $folder"
  fi
done

# Set a timer for the script to continue
(sleep $TIMER && printf "\n${YELLOW}Script continuing${RESET}\n") & waitpid=$!

# Define a signal trap to catch SIGTERM and stop the script gracefully
trap 'printf "\n${RED}Script stopped by user${RESET}\n" && kill $waitpid && exit 1' SIGTERM

# Prompt the user for input to continue or stop the script
printf "${YELLOW}All scripts updated! Press any key to continue or 's' to stop the script. The script will continue automatically after $TIMER seconds.${RESET}\n"
read -n 1 -s -r -t $TIMER response

# Stop or continue the script based on user input
[ "$response" = "s" ] && printf "\n${RED}Stopping script...${RESET}\n" && kill $waitpid && exit 1
printf "\n${GREEN}Continuing script...${RESET}\n" && kill $waitpid

# Run the main conversion script
echo Running the selection script
nice -n 10 "./conversion-script-selector.sh"