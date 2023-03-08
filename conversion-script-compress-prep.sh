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

echo -e "${BOLD}${CYAN}"
cat << "EOF"

 ▄▄·       ▄▄▄  ▄▄▄ .• ▌ ▄ ·. ▄▄▌  
▐█ ▌▪▪     ▀▄ █·▀▄.▀··██ ▐███▪██•  
██ ▄▄ ▄█▀▄ ▐▀▀▄ ▐▀▀▪▄▐█ ▌▐▌▐█·██▪  
▐███▌▐█▌.▐▌▐█•█▌▐█▄▄▌██ ██▌▐█▌▐█▌▐▌
·▀▀▀  ▀█▄▀▪.▀  ▀ ▀▀▀ ▀▀  █▪▀▀▀.▀▀▀ 

Compression Script
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

# List of model directories
models=(
        "${MODEL_NAME}_split-einsum" 
		"${MODEL_NAME}_split-einsum_om-vae" 
        "${MODEL_NAME}_split-einsum_mm2-vae" 
        "${MODEL_NAME}_split-einsum_vae-1.5" 
        "${MODEL_NAME}_split-einsum_vae-2.1" 
        "${MODEL_NAME}_original" 
		"${MODEL_NAME}_original_om-vae" 
        "${MODEL_NAME}_original_mm2-vae" 
        "${MODEL_NAME}_original_vae-1.5" 
        "${MODEL_NAME}_original_vae-2.1" 
		"${MODEL_NAME}_original_256x256"
		"${MODEL_NAME}_original_256x256_om-vae"
		"${MODEL_NAME}_original_256x256_mm2-vae"
		"${MODEL_NAME}_original_256x256_vae-1.5"
		"${MODEL_NAME}_original_256x256_vae-2.1"
		"${MODEL_NAME}_original_320x320"
		"${MODEL_NAME}_original_320x320_om-vae"
		"${MODEL_NAME}_original_320x320_mm2-vae"
		"${MODEL_NAME}_original_320x320_vae-1.5"
		"${MODEL_NAME}_original_320x320_vae-2.1"
		"${MODEL_NAME}_original_384x384"
		"${MODEL_NAME}_original_384x384_om-vae"
		"${MODEL_NAME}_original_384x384_mm2-vae"
		"${MODEL_NAME}_original_384x384_vae-1.5"
		"${MODEL_NAME}_original_384x384_vae-2.1"
		"${MODEL_NAME}_original_576x576"
		"${MODEL_NAME}_original_576x576_om-vae"
		"${MODEL_NAME}_original_576x576_mm2-vae"
		"${MODEL_NAME}_original_576x576_vae-1.5"
		"${MODEL_NAME}_original_576x576_vae-2.1"
		"${MODEL_NAME}_original_384x256"
		"${MODEL_NAME}_original_384x256_om-vae"
		"${MODEL_NAME}_original_384x256_mm2-vae"
		"${MODEL_NAME}_original_384x256_vae-1.5"
		"${MODEL_NAME}_original_384x256_vae-2.1"
		"${MODEL_NAME}_original_256x384"
		"${MODEL_NAME}_original_256x384_om-vae"
		"${MODEL_NAME}_original_256x384_mm2-vae"
		"${MODEL_NAME}_original_256x384_vae-1.5"
		"${MODEL_NAME}_original_256x384_vae-2.1"
		"${MODEL_NAME}_original_576x320"
		"${MODEL_NAME}_original_576x320_om-vae"
		"${MODEL_NAME}_original_576x320_mm2-vae"
		"${MODEL_NAME}_original_576x320_vae-1.5"
		"${MODEL_NAME}_original_576x320_vae-2.1"
		"${MODEL_NAME}_original_320x576"
		"${MODEL_NAME}_original_320x576_om-vae"
		"${MODEL_NAME}_original_320x576_mm2-vae"
		"${MODEL_NAME}_original_320x576_vae-1.5"
		"${MODEL_NAME}_original_320x576_vae-2.1"
		"${MODEL_NAME}_original_512x768"
		"${MODEL_NAME}_original_512x768_om-vae"
		"${MODEL_NAME}_original_512x768_mm2-vae"
		"${MODEL_NAME}_original_512x768_vae-1.5"
		"${MODEL_NAME}_original_512x768_vae-2.1"
		"${MODEL_NAME}_original_768x512"
		"${MODEL_NAME}_original_768x512_om-vae"
		"${MODEL_NAME}_original_768x512_mm2-vae"
		"${MODEL_NAME}_original_768x512_vae-1.5"
		"${MODEL_NAME}_original_768x512_vae-2.1"
		"${MODEL_NAME}_original_768x768"
		"${MODEL_NAME}_original_768x768_om-vae"
		"${MODEL_NAME}_original_768x768_mm2-vae"
		"${MODEL_NAME}_original_768x768_vae-1.5"
		"${MODEL_NAME}_original_768x768_vae-2.1"
        "${MODEL_NAME}_split-einsum_pruned" 
		"${MODEL_NAME}_split-einsum_om-vae_pruned" 
        "${MODEL_NAME}_split-einsum_mm2-vae_pruned" 
        "${MODEL_NAME}_split-einsum_vae-1.5_pruned" 
        "${MODEL_NAME}_split-einsum_vae-2.1_pruned" 
        "${MODEL_NAME}_original_pruned" 
		"${MODEL_NAME}_original_om-vae_pruned" 
        "${MODEL_NAME}_original_mm2-vae_pruned" 
        "${MODEL_NAME}_original_vae-1.5_pruned" 
        "${MODEL_NAME}_original_vae-2.1_pruned" 
		"${MODEL_NAME}_original_256x256_pruned"
		"${MODEL_NAME}_original_256x256_om-vae_pruned"
		"${MODEL_NAME}_original_256x256_mm2-vae_pruned"
		"${MODEL_NAME}_original_256x256_vae-1.5_pruned"
		"${MODEL_NAME}_original_256x256_vae-2.1_pruned"
		"${MODEL_NAME}_original_320x320_pruned"
		"${MODEL_NAME}_original_320x320_om-vae_pruned"
		"${MODEL_NAME}_original_320x320_mm2-vae_pruned"
		"${MODEL_NAME}_original_320x320_vae-1.5_pruned"
		"${MODEL_NAME}_original_320x320_vae-2.1_pruned"
		"${MODEL_NAME}_original_384x384_pruned"
		"${MODEL_NAME}_original_384x384_om-vae_pruned"
		"${MODEL_NAME}_original_384x384_mm2-vae_pruned"
		"${MODEL_NAME}_original_384x384_vae-1.5_pruned"
		"${MODEL_NAME}_original_384x384_vae-2.1_pruned"
		"${MODEL_NAME}_original_576x576_pruned"
		"${MODEL_NAME}_original_576x576_om-vae_pruned"
		"${MODEL_NAME}_original_576x576_mm2-vae_pruned"
		"${MODEL_NAME}_original_576x576_vae-1.5_pruned"
		"${MODEL_NAME}_original_576x576_vae-2.1_pruned"
		"${MODEL_NAME}_original_384x256_pruned"
		"${MODEL_NAME}_original_384x256_om-vae_pruned"
		"${MODEL_NAME}_original_384x256_mm2-vae_pruned"
		"${MODEL_NAME}_original_384x256_vae-1.5_pruned"
		"${MODEL_NAME}_original_384x256_vae-2.1_pruned"
		"${MODEL_NAME}_original_256x384_pruned"
		"${MODEL_NAME}_original_256x384_om-vae_pruned"
		"${MODEL_NAME}_original_256x384_mm2-vae_pruned"
		"${MODEL_NAME}_original_256x384_vae-1.5_pruned"
		"${MODEL_NAME}_original_256x384_vae-2.1_pruned"
		"${MODEL_NAME}_original_576x320_pruned"
		"${MODEL_NAME}_original_576x320_om-vae_pruned"
		"${MODEL_NAME}_original_576x320_mm2-vae_pruned"
		"${MODEL_NAME}_original_576x320_vae-1.5_pruned"
		"${MODEL_NAME}_original_576x320_vae-2.1_pruned"
		"${MODEL_NAME}_original_320x576_pruned"
		"${MODEL_NAME}_original_320x576_om-vae_pruned"
		"${MODEL_NAME}_original_320x576_mm2-vae_pruned"
		"${MODEL_NAME}_original_320x576_vae-1.5_pruned"
		"${MODEL_NAME}_original_320x576_vae-2.1_pruned"
		"${MODEL_NAME}_original_512x768_pruned"
		"${MODEL_NAME}_original_512x768_om-vae_pruned"
		"${MODEL_NAME}_original_512x768_mm2-vae_pruned"
		"${MODEL_NAME}_original_512x768_vae-1.5_pruned"
		"${MODEL_NAME}_original_512x768_vae-2.1_pruned"
		"${MODEL_NAME}_original_768x512_pruned"
		"${MODEL_NAME}_original_768x512_om-vae_pruned"
		"${MODEL_NAME}_original_768x512_mm2-vae_pruned"
		"${MODEL_NAME}_original_768x512_vae-1.5_pruned"
		"${MODEL_NAME}_original_768x512_vae-2.1_pruned"
		"${MODEL_NAME}_original_768x768_pruned"
		"${MODEL_NAME}_original_768x768_om-vae_pruned"
		"${MODEL_NAME}_original_768x768_mm2-vae_pruned"
		"${MODEL_NAME}_original_768x768_vae-1.5_pruned"
		"${MODEL_NAME}_original_768x768_vae-2.1_pruned"
      )

# Function to zip a model directory and exclude any .DS_Store files
zip_model() {
    if [ ! -f "${COMPRESSED_DUMP}/$1.zip" ]; then
        zip -vr "${COMPRESSED_DUMP}/$1.zip" $1/ -x "*.DS_Store" &&
        sleep 1
    else
        echo "Zip file already exists for $1, skipping..."
    fi
}

# Loop through each model directory and compress it
for model in "${models[@]}"; do
    cd "${MODELS_DUMP}"
#    cd "${WORK_DIR}/Models"
    zip_model $model
done

uploads_dir="${COMPRESSED_DUMP}"
original_dir="${COMPRESSED_DUMP}/original"

if [ ! -d "$uploads_dir" ]; then
  mkdir -vp "$uploads_dir"
fi

dirs=("$original_dir/256x256"
	  "$original_dir/320x320"
	  "$original_dir/384x384"
	  "$original_dir/576x576"
      "$original_dir/384x256"
      "$original_dir/256x384"
      "$original_dir/576x320"
      "$original_dir/512x768"
      "$original_dir/768x512"
      "$original_dir/768x768"
      "${COMPRESSED_DUMP}/split-einsum")

for dir in "${dirs[@]}"; do
  if [ ! -d "$dir" ]; then
    mkdir -vp "$dir"
  fi
done

for file in "$uploads_dir"/*.zip; do
  if [ -f "$file" ]; then
    size=$(echo "$file" | sed -n 's/.*_\([0-9]*x[0-9]*\).*/\1/p')
    if [ -n "$size" ]; then
      size_dir="$original_dir/$size"
      if [ ! -d "$size_dir" ]; then
        mkdir -vp "$size_dir"
      fi
      mv -v "$file" "$size_dir/$(basename "$file")"
    elif [[ "$file" == *"original"* ]]; then
      mv -v "$file" "$original_dir/$(basename "$file")"
    elif [[ "$file" == *"split-einsum"* ]]; then
      mv -v "$file" "${COMPRESSED_DUMP}/split-einsum/$(basename "$file")"
    fi
  fi
done


echo "${GREEN} DONE! ${RESET}"
echo ""