#!/bin/bash

# Define color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)
RESET=$(tput sgr 0)

# Change the working directory to the script directory
cd "$(dirname "${BASH_SOURCE[0]}")"

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
	find . -maxdepth 1 -type f ! -name '*.'$EXTENSION ! -name '*.'ckpt ! -name '*.'safetensors ! -name '.*' ! -path './Archive/*' ! -path './Diffusers/*' ! -path './Embedded Pickles/*' ! -path './links/*' ! -path './misc/*' ! -path './Models/*' ! -path './other scripts/*' ! -path './Safe-and-Stable-Ckpt2Safetensors-Conversion-Tool-GUI/*' ! -path './test scripts/*' ! -path './VAE/*' ! -path './yaml/*' -exec zip -r "backups/$BACKUP_NAME" {} +

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
