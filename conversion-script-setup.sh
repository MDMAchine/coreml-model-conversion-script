#!/bin/bash

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

##############################################################################################
echo -e "${BOLD}${YELLOW}"
cat << "EOF"
##############################################################################################
EOF
echo -e "${BOLD}${RED}"
cat << "EOF"
CONVERSION SCRIPT BY:
     _____        _____         _____        _____                                             
 ___|    _|__  __|__   |__  ___|    _|__  __|_    |__  ______  __   _  ____  ____   _  ______
|    \  /  | ||     \     ||    \  /  | ||    \      ||   ___||  |_| ||    ||    \ | ||   ___| 
|     \/   | ||      \    ||     \/   | ||     \     ||   |__ |   _  ||    ||     \| ||   ___| 
|__/\__/|__|_||______/  __||__/\__/|__|_||__|\__\  __||______||__| |_||____||__/\____||______| 
    |_____|      |_____|       |_____|      |_____|                                            
EOF
echo -e "${BOLD}${YELLOW}"
cat << "EOF"
##############################################################################################
EOF
echo -e "${RESET}"
cat << "EOF"
EOF
sleep 3

chmod 755 ./*

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
echo "${RED}Current model name is:${RESET} ${GREEN}$MODEL_NAME${RESET}"
sleep 1
echo ""

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
	find . -maxdepth 1 -type f ! -name '*.ckpt' ! -name '.*' ! -path './Archive/*' ! -path './Diffusers/*' ! -path './Embedded Pickles/*' ! -path './links/*' ! -path './misc/*' ! -path './Models/*' ! -path './other scripts/*' ! -path './Safe-and-Stable-Ckpt2Safetensors-Conversion-Tool-GUI/*' ! -path './test scripts/*' ! -path './VAE/*' ! -path './yaml/*' -exec zip -r "backups/$BACKUP_NAME" {} +

    # Execute command if user chooses to update variables
    echo -e "${GREEN}Updating variables${RESET}"
    nice -n 10 ./conversion-script-variables.sh
else
    echo -e "${YELLOW}Skipping variable update${RESET}"
fi

#########################################################################

# Prompt the user to update the model name
read -p "Do you want to update the model filename? (Do not include the extension) (y/n) " answer
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
	find . -maxdepth 1 -type f ! -name '*.ckpt' ! -name '.*' ! -path './Archive/*' ! -path './Diffusers/*' ! -path './Embedded Pickles/*' ! -path './links/*' ! -path './misc/*' ! -path './Models/*' ! -path './other scripts/*' ! -path './Safe-and-Stable-Ckpt2Safetensors-Conversion-Tool-GUI/*' ! -path './test scripts/*' ! -path './VAE/*' ! -path './yaml/*' -exec zip -r "backups/$BACKUP_NAME" {} +


    # Prompt the user for input
    read -p "Enter new model name: " input

    # Update MODEL_NAME in files containing 'conversion-script'
    export LANG=C # Set the LANG environment variable to C
	find . -type f -name "*conversion-script*" ! -path "./backups/*" -exec sed -i '' "s/MODEL_NAME=\".*\"/MODEL_NAME=\"$input\"/" {} \;

    echo -e "${GREEN}Model name updated${RESET}"
else
    echo -e "${YELLOW}Skipping model name update${RESET}"
fi

###################################################################

# Define variables
FOLDERS=("Diffusers" "Embedded Pickles" "Models" "VAE")
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

###################################################################