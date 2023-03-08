#!/bin/bash

# Define color variables
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CYAN=$(tput setaf 6)
RESET=$(tput sgr 0)

# Define the variables
ROOT_DIR="/ml-stable-diffusion-main"
WORK_DIR="/ml-stable-diffusion-main/work"
MODELS_LOAD="/Volumes/External Drive/Model Archive"
COMPRESSED_DUMP="/Volumes/External Drive/Uploads"

# Prompt the user to update the variables
echo
echo "${CYAN}Here you can update variables:${RESET}"
echo "${RED}ROOT_DIR${RESET} is the location of the ml-stable-diffusion folder."
echo "${RED}WORK_DIR${RESET} is wherever these scripts are located."
echo "${RED}MODELS_LOAD${RESET} is wherever your model files (ckpt) are located."
echo "${RED}COMPRESSED_DUMP${RESET} is where the compression script will output the zips."
echo

read -p "Ready to edit the variables? (y/n) " choice

if [ "$choice" == "y" ]; then
  read -p "Enter the new value for ROOT_DIR (default: $ROOT_DIR): " new_ROOT_DIR
  new_ROOT_DIR="${new_ROOT_DIR:-$ROOT_DIR}"

  read -p "Enter the new value for WORK_DIR (default: $WORK_DIR): " new_WORK_DIR
  new_WORK_DIR="${new_WORK_DIR:-$WORK_DIR}"

  read -p "Enter the new value for MODELS_LOAD (default: $MODELS_LOAD): " new_MODELS_LOAD
  new_MODELS_LOAD="${new_MODELS_LOAD:-$MODELS_LOAD}"

  read -p "Enter the new value for COMPRESSED_DUMP (default: $COMPRESSED_DUMP): " new_COMPRESSED_DUMP
  new_COMPRESSED_DUMP="${new_COMPRESSED_DUMP:-$COMPRESSED_DUMP}"

  # Set the new values if provided, otherwise use the defaults
  ROOT_DIR="$new_ROOT_DIR"
  WORK_DIR="$new_WORK_DIR"
  MODELS_LOAD="$new_MODELS_LOAD"
  COMPRESSED_DUMP="$new_COMPRESSED_DUMP"

  # Save the new values to the .sh files excluding conversion-script-variables.sh
  for file in $(ls *.sh | grep -v conversion-script-variables.sh); do
    sed -i '' "s|ROOT_DIR=\".*\"|ROOT_DIR=\"$ROOT_DIR\"|" "$file"
    sed -i '' "s|WORK_DIR=\".*\"|WORK_DIR=\"$WORK_DIR\"|" "$file"
    sed -i '' "s|MODELS_LOAD=\".*\"|MODELS_LOAD=\"$MODELS_LOAD\"|" "$file"
    sed -i '' "s|COMPRESSED_DUMP=\".*\"|COMPRESSED_DUMP=\"$COMPRESSED_DUMP\"|" "$file"
  done
  
  echo "The variables have been updated."
  
else
  echo "No changes were made to the variables."
fi