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

VAE Embedding                                      
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

#########################################################################
#	SETUP
#########################################################################

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

#########################################################################
#	DOWNLOADS
#########################################################################

# Check for the VAE files and if not found download them

VAE_DIR="${VAE_LOAD}"
FILE_1="moistmixv2-diffusion_pytorch_model.bin"
FILE_2="orangemix-diffusion_pytorch_model.bin"
FILE_3="2.1-diffusion_pytorch_model.bin"
FILE_4="1.5-diffusion_pytorch_model.bin"
FILE_URL_1="https://huggingface.co/mdmachine/VAE/resolve/main/VAE/moistmixv2-diffusion_pytorch_model.bin"
FILE_URL_2="https://huggingface.co/mdmachine/VAE/resolve/main/VAE/orangemix-diffusion_pytorch_model.bin"
FILE_URL_3="https://huggingface.co/mdmachine/VAE/resolve/main/VAE/2.1-diffusion_pytorch_model.bin"
FILE_URL_4="https://huggingface.co/mdmachine/VAE/resolve/main/VAE/1.5-diffusion_pytorch_model.bin"

if [ ! -d "$VAE_DIR" ]; then
  mkdir "$VAE_DIR"
fi

# curl method

if [ ! -f "$VAE_DIR/$FILE_1" ]; then
  echo "Downloading $FILE_1"
  curl -# -L "$FILE_URL_1" -o "$VAE_DIR/$FILE_1"
fi

if [ ! -f "$VAE_DIR/$FILE_2" ]; then
  echo "Downloading $FILE_2"
  curl -# -L "$FILE_URL_2" -o "$VAE_DIR/$FILE_2"
fi

if [ ! -f "$VAE_DIR/$FILE_3" ]; then
  echo "Downloading $FILE_3"
  curl -# -L "$FILE_URL_3" -o "$VAE_DIR/$FILE_3"
fi

if [ ! -f "$VAE_DIR/$FILE_4" ]; then
  echo "Downloading $FILE_4"
  curl -# -L "$FILE_URL_4" -o "$VAE_DIR/$FILE_4"
fi

#########################################################################
#	DIFFUSERS
#########################################################################

# Change directory to Stable Diffusion project
cd "${ROOT_DIR}"

start=$SECONDS

# Function to create diffusers from a specified checkpoint path and dump path
function create_diffusers() {
    local checkpoint_path="$1"
    local dump_path="$2"
    local count=1
    local attempts=3
    local from_safetensors_arg=""
    local from_custom_config=""
    
# ask if the user wants to use a custom config file
read -t 10 -p "${RED}Use a custom config file?${RESET} (y/n) ${YELLOW}Skipping in 10 seconds.${RESET} " custom_config

# if there is no input in 10 seconds, continue on
if [ -z "$custom_config" ]; then
    echo "${RED}No input received. Skipping custom config.${RESET}"
else
    if [ "$custom_config" == "y" ]; then
        echo "${RED}Listing available config files in /yaml:${RESET}"
        find "${WORK_DIR}/yaml" -type f -name '*.yaml' | cat -n
        read -p "${RED}Enter the number of the custom config file you want to use:${RESET} " config_input_number
        config_input="$(find "${WORK_DIR}/yaml" -type f -name '*.yaml' | sed -n ${config_input_number}p)"
        from_custom_config="--original_config_file ${config_input}"
    else
        echo "${RED}Skipping custom config.${RESET}"
    fi
fi

    if [ "$EXTENSION" = "safetensors" ]; then
        from_safetensors_arg="--from_safetensors"
    fi

    if [ -d "${dump_path}" ]; then
        echo "${YELLOW} ${dump_path} directory exists. Skipping diffuser creation. ${RESET}"
        return 0
    fi

    # Try creating diffusers with given checkpoint path and dump path up to 3 times
    for ((i=1; i<=$attempts; i++)); do
        if python convert_original_stable_diffusion_to_diffusers.py --checkpoint_path "${checkpoint_path}" ${from_custom_config:+--original_config_file "$config_input"} --device cpu --extract_ema --dump_path "${dump_path}" --upcast_attention $from_safetensors_arg; then
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
    [[ $count -eq $attempts ]] && echo "${RED} Skipping after too many attempts ${RESET}"

    # Print message for successful creation
    echo "${GREEN} The conversion of the workfile into diffusers is complete ${RESET}"
    echo ""
}

# Create diffusers from raw workfile
echo "${RED} Now creating diffusers from the raw workfile into diffusers... ${RESET}"
create_diffusers "${MODELS_LOCAL}.${EXTENSION}" "${DIFFUSERS_DUMP}/${MODEL_NAME}_raw_diffusers_model/"

# Print the duration of the diffuser creation process
end=$SECONDS
duration=$(( end - start ))
echo "${GREEN} The conversion of diffusers took $duration seconds to complete ${RESET}"

#########################################################################
#	DUPLICATION
#########################################################################

# Define function to print message in green color
print_message() {
    printf "${GREEN}%s${RESET}\n" "$1"
}

# Define function to print error message in red color
print_error() {
    printf "${RED}%s${RESET}\n" "$1" >&2
}

# Define function to duplicate and copy diffusers
duplicate_and_copy_diffusers() {
    local source_dir="$1"
    local dest_dir="$2"
    local vae_file="$3"
    local vae_source="$4"
    
    print_message "Duplicating..."
    if cp -v -r "$source_dir/${MODEL_NAME}_raw_diffusers_model" "$dest_dir/${MODEL_NAME}_${vae_file}_diffusers_model"; then
        print_message "Duplicating complete."
    else
        print_error "Error duplicating diffusers."
        return 1
    fi
    
    print_message "Copying vae now..."
    if cp -v "$VAE_LOAD/$vae_source-diffusion_pytorch_model.bin" "$dest_dir/${MODEL_NAME}_${vae_file}_diffusers_model/vae/diffusion_pytorch_model.bin"; then
        print_message "Copy complete."
    else
        print_error "Error copying vae."
        return 1
    fi
}

# Duplicate and copy diffusers for 1.5 SD
start=$SECONDS
if duplicate_and_copy_diffusers "$DIFFUSERS_DUMP" "$DIFFUSERS_DUMP" "ema-vae-1.5" "1.5"; then
    duration=$(( SECONDS - start ))
    printf "\n%s Duplication & copy took %d seconds to complete.\n\n" "$(tput setaf 2)" "$duration"
    sleep 0.3
fi

# Duplicate and copy diffusers for 2.1 SD
print_message "Duplicating raw diffusers and replace VAE with SD 2.1"
sleep 1
start=$SECONDS
if duplicate_and_copy_diffusers "$DIFFUSERS_DUMP" "$DIFFUSERS_DUMP" "ema-vae-2.1" "2.1"; then
    duration=$(( SECONDS - start ))
    printf "\n%s Duplication & copy took %d seconds to complete.\n\n" "$(tput setaf 2)" "$duration"
fi

# Duplicate and copy diffusers for orangemix
print_message "Duplicating raw diffusers and replace VAE with orangemix"
sleep 1
start=$SECONDS
if duplicate_and_copy_diffusers "$DIFFUSERS_DUMP" "$DIFFUSERS_DUMP" "orangemix-vae" "orangemix"; then
    duration=$(( SECONDS - start ))
    printf "\n%s Duplication & copy took %d seconds to complete.\n\n" "$(tput setaf 2)" "$duration"
fi

# Duplicate and copy diffusers for 2.1 SD
print_message "Duplicating raw diffusers and replace VAE with SD 2.1"
sleep 1
start=$SECONDS
if duplicate_and_copy_diffusers "$DIFFUSERS_DUMP" "$DIFFUSERS_DUMP" "moistmixv2-vae" "moistmixv2"; then
    duration=$(( SECONDS - start ))
    printf "\n%s Duplication & copy took %d seconds to complete.\n\n" "$(tput setaf 2)" "$duration"
fi

####################################################################
#	CLEANUP
####################################################################
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

echo ""
echo "${GREEN}Done!${RESET}"
echo ""