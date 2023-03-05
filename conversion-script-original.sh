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

ORIGINAL Conversion                                    
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
#	CONVERSION
###################################################################

start=$SECONDS

# Set the maximum number of attempts for each model conversion
ATTEMPTS=20

# Function to convert the model and handle errors
function convert_model() {
    # Set the model name to be converted
    model_name=$1

    # Set the output name for the converted model
    output_name="${model_name%_diffusers_model}_original_compiled"

    # Initialize the attempt counter
    count=1

    # Loop until the model is successfully converted or the maximum number of attempts is reached
    until python -m python_coreml_stable_diffusion.torch2coreml \
        --convert-unet \
        --convert-text-encoder \
        --convert-vae-encoder \
        --convert-vae-decoder \
        --convert-safety-checker \
        --model-version ./Diffusers/"${model_name}" \
        --bundle-resources-for-swift-cli \
        --attention-implementation ORIGINAL \
        -o ./"${output_name}" || [[ $count -eq $ATTEMPTS ]]; do
            # Handle conversion errors by respawning the conversion
            echo "${CYAN} Conversion killed with exit code $?.  Respawning.. ${RESET}" >&2
            echo -e "${YELLOW}Retrying #$(( count++ )) out of ${ATTEMPTS}... ${RESET} \c"
            echo ""
            sleep 1
    done

    # If the maximum number of attempts was reached, skip the model and print an error message
    [[ $count -eq $ATTEMPTS ]] && echo "${RED} Skipping ${model_name} after too many attempts ${RESET}"
}

# Convert each model using the convert_model function
#convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model"
#convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model"
convert_model "${MODEL_NAME}_raw_diffusers_model"
#convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model"
#convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model"

# Define the target model names as variables
old_model_names=(
    "${MODEL_NAME}_orangemix-vae_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_original_compiled/Resources/"
    "${MODEL_NAME}_raw_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_original_compiled/Resources/"
)
new_model_names=(
    "${MODEL_NAME}_original_om-vae"
    "${MODEL_NAME}_original_mm2-vae"
    "${MODEL_NAME}_original"
    "${MODEL_NAME}_original_vae-1.5"
    "${MODEL_NAME}_original_vae-2.1"
)

# Perform the model name replacement for all target model names
for (( i=0; i<${#old_model_names[@]}; i++ )); do
    echo "${RED} Cleaning up ${old_model_names[i]}! ${RESET}"
    mv "./${old_model_names[i]}" "./models/${new_model_names[i]}"
done

# Calculate and display the duration of the conversion process
end=$SECONDS
duration=$(( end - start ))

# Prompt the user to check that all operations have completed correctly before continuing
echo "${RED}🚨 Removing all work files. Check that all operations have completed correctly before continuing! 🚨${RESET}"
echo "${YELLOW}Press any key to continue, or 's' to stop the script (you have 60 seconds)...${RESET}"
read -n 1 -s -r -t 60 response

# Check if the user input is empty (no response)
if [ -z "$response" ]; then
  echo "${GREEN}✅ Continuing with the script...${RESET}"
else
  # Check if the user input is 's' (stop)
  if [ "$response" == "s" ]; then
    echo "${RED}❌ Script stopped by user.❌${RESET}"
    exit 1
  else
    echo "${GREEN}✅ Continuing with the script...${RESET}"
  fi
fi

# Remove all work files
rm -rf ./${MODEL_NAME}_orangemix-vae_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_original_compiled
rm -rf ./${MODEL_NAME}_raw_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_original_compiled

echo ""
echo "${GREEN} Conversion of original models took $duration seconds to complete ${RESET}"
echo ""