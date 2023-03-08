#!/bin/bash
VERSION=0.7.3

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

ORGINAL Custom Resolutions                                       
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

####################################################################
#	CUSTOM
####################################################################

start=$SECONDS

# Function to convert a model with the given configuration
function convert_model() {
    model_name=$1
    latent_h=$2
    latent_w=$3
    output_name=$4

    # Set the maximum number of attempts to 20
    attempts=20
    count=1
    
        # Set the output name for the converted model
    if [[ $PYTHON_MODULE == "python_coreml_stable_diffusion.torch2coreml" ]]; then
        output_name="${output_name}_pruned"
    else
        output_name="${output_name}"
    fi

    # Loop until the model is successfully converted or the maximum number of attempts is reached
    until python -m $PYTHON_MODULE \
            --compute-unit CPU_AND_GPU \
            --convert-unet \
            --convert-text-encoder \
            --convert-vae-encoder \
            --convert-vae-decoder \
            --convert-safety-checker \
            --model-version "./Diffusers/${model_name}" \
            --bundle-resources-for-swift-cli \
            --attention-implementation ORIGINAL \
            --latent-h ${latent_h} \
            --latent-w ${latent_w} \
            -o "./${output_name}" || [[ $count -eq $attempts ]]; do
        # Handle conversion errors by respawning the conversion
        echo "${CYAN} Conversion killed with exit code $?.  Respawning.. ${RESET}" >&2
        echo -e "${YELLOW} Retrying #$((count++)) out of ${attempts}... ${RESET} \c"
        echo ""
        sleep 1
        
    done

    # If the maximum number of attempts was reached, skip the model and print an error message
    [[ $count -eq $ATTEMPTS ]] && echo "${RED} Skipping ${model_name} after too many attempts ${RESET}"
}

# Prompt the user to select the model type
echo "Please select the model type to create (Default after 15 seconds):"
echo "1. 16 bit (pruned)"
echo "2. 32 bit"
echo -n "Your selection (default: 2): "
read -t 15 model_type

# Set the Python module based on the user's selection or the default (32 bit)
if [[ $model_type -eq 1 ]]; then
    PYTHON_MODULE=python_coreml_stable_diffusion.torch2coreml
else
    PYTHON_MODULE=python_coreml_stable_diffusion.torch2coreml_fp32
fi

# Convert the models with the given configurations

# - 256x256
convert_model "${MODEL_NAME}_raw_diffusers_model" 32 32 "${MODEL_NAME}_raw_256x256_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 32 32 "${MODEL_NAME}_orangemix-vae_256x256_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 32 32 "${MODEL_NAME}_moistmixv2-vae_256x256_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 32 32 "${MODEL_NAME}_ema-vae-1.5_256x256_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 32 32 "${MODEL_NAME}_ema-vae-2.1_256x256_original_compiled"
# - 320x320
convert_model "${MODEL_NAME}_raw_diffusers_model" 40 40 "${MODEL_NAME}_raw_320x320_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 40 40 "${MODEL_NAME}_orangemix-vae_320x320_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 40 40 "${MODEL_NAME}_moistmixv2-vae_320x320_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 40 40 "${MODEL_NAME}_ema-vae-1.5_320x320_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 40 40 "${MODEL_NAME}_ema-vae-2.1_320x320_original_compiled"
# - 384x384
convert_model "${MODEL_NAME}_raw_diffusers_model" 48 48 "${MODEL_NAME}_raw_384x384_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 48 48 "${MODEL_NAME}_orangemix-vae_384x384_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 48 48 "${MODEL_NAME}_moistmixv2-vae_384x384_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 48 48 "${MODEL_NAME}_ema-vae-1.5_384x384_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 48 48 "${MODEL_NAME}_ema-vae-2.1_384x384_original_compiled"
# - 576x576
convert_model "${MODEL_NAME}_raw_diffusers_model" 72 72 "${MODEL_NAME}_raw_576x576_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 72 72 "${MODEL_NAME}_orangemix-vae_576x576_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 72 72 "${MODEL_NAME}_moistmixv2-vae_576x576_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 72 72 "${MODEL_NAME}_ema-vae-1.5_576x576_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 72 72 "${MODEL_NAME}_ema-vae-2.1_576x576_original_compiled"
# - 384x256
convert_model "${MODEL_NAME}_raw_diffusers_model" 32 48 "${MODEL_NAME}_raw_384x256_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 32 48 "${MODEL_NAME}_orangemix-vae_384x256_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 32 48 "${MODEL_NAME}_moistmixv2-vae_384x256_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 32 48 "${MODEL_NAME}_ema-vae-1.5_384x256_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 48 32 "${MODEL_NAME}_ema-vae-2.1_384x256_original_compiled"
# - 256x384
convert_model "${MODEL_NAME}_raw_diffusers_model" 48 32 "${MODEL_NAME}_raw_256x384_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 32 48 "${MODEL_NAME}_orangemix-vae_256x384_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 32 48 "${MODEL_NAME}_moistmixv2-vae_256x384_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 32 48 "${MODEL_NAME}_ema-vae-1.5_256x384_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 48 32 "${MODEL_NAME}_ema-vae-2.1_256x384_original_compiled"
# - 576x320
convert_model "${MODEL_NAME}_raw_diffusers_model" 40 72 "${MODEL_NAME}_raw_576x320_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 40 72 "${MODEL_NAME}_orangemix-vae_576x320_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 40 72 "${MODEL_NAME}_moistmixv2-vae_576x320_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 40 72 "${MODEL_NAME}_ema-vae-1.5_576x320_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 40 72 "${MODEL_NAME}_ema-vae-2.1_576x320_original_compiled"
# - 320x576
convert_model "${MODEL_NAME}_raw_diffusers_model" 72 40 "${MODEL_NAME}_raw_320x576_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 72 40 "${MODEL_NAME}_orangemix-vae_320x576_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 72 40 "${MODEL_NAME}_moistmixv2-vae_320x576_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 72 40 "${MODEL_NAME}_ema-vae-1.5_320x576_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 72 40 "${MODEL_NAME}_ema-vae-2.1_320x576_original_compiled"
# - 512x768
convert_model "${MODEL_NAME}_raw_diffusers_model" 96 64 "${MODEL_NAME}_raw_512x768_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 96 64 "${MODEL_NAME}_orangemix-vae_512x768_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 96 64 "${MODEL_NAME}_moistmixv2-vae_512x768_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 96 64 "${MODEL_NAME}_ema-vae-1.5_512x768_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 96 64 "${MODEL_NAME}_ema-vae-2.1_512x768_original_compiled"
# - 768x512
convert_model "${MODEL_NAME}_raw_diffusers_model" 64 96 "${MODEL_NAME}_raw_768x512_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 64 96 "${MODEL_NAME}_orangemix-vae_768x512_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 64 96 "${MODEL_NAME}_moistmixv2-vae_768x512_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 64 96 "${MODEL_NAME}_ema-vae-1.5_768x512_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 64 96 "${MODEL_NAME}_ema-vae-2.1_768x512_original_compiled"
# - 768x768
convert_model "${MODEL_NAME}_raw_diffusers_model" 96 96 "${MODEL_NAME}_raw_768x768_original_compiled"
##convert_model "${MODEL_NAME}_orangemix-vae_diffusers_model" 96 96 "${MODEL_NAME}_orangemix-vae_768x768_original_compiled"
##convert_model "${MODEL_NAME}_moistmixv2-vae_diffusers_model" 96 96 "${MODEL_NAME}_moistmixv2-vae_768x768_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-1.5_diffusers_model" 96 96 "${MODEL_NAME}_ema-vae-1.5_768x768_original_compiled"
##convert_model "${MODEL_NAME}_ema-vae-2.1_diffusers_model" 96 96 "${MODEL_NAME}_ema-vae-2.1_768x768_original_compiled"

####################################################################
#	CLEANUP
####################################################################

# Define the target model names as variables
old_model_names=(
    "${MODEL_NAME}_raw_256x256_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_256x256_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_256x256_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_256x256_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_256x256_original_compiled/Resources/"
    "${MODEL_NAME}_raw_320x320_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_320x320_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_320x320_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_320x320_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_320x320_original_compiled/Resources/"
    "${MODEL_NAME}_raw_384x384_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_384x384_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_384x384_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_384x384_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_384x384_original_compiled/Resources/"
    "${MODEL_NAME}_raw_576x576_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_576x576_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_576x576_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_576x576_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_576x576_original_compiled/Resources/"
    "${MODEL_NAME}_raw_384x256_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_384x256_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_384x256_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_384x256_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_384x256_original_compiled/Resources/"
    "${MODEL_NAME}_raw_256x384_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_256x384_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_256x384_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_256x384_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_256x384_original_compiled/Resources/"
    "${MODEL_NAME}_raw_576x320_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_576x320_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_576x320_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_576x320_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_576x320_original_compiled/Resources/"
    "${MODEL_NAME}_raw_320x576_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_320x576_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_320x576_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_320x576_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_320x576_original_compiled/Resources/"
    "${MODEL_NAME}_raw_512x768_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_512x768_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_512x768_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_512x768_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_512x768_original_compiled/Resources/"
    "${MODEL_NAME}_raw_768x512_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_768x512_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_768x512_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_768x512_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_768x512_original_compiled/Resources/"
    "${MODEL_NAME}_raw_768x768_original_compiled/Resources/"
    "${MODEL_NAME}_orangemix-vae_768x768_original_compiled/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_768x768_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_768x768_original_compiled/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_768x768_original_compiled/Resources/"
    "${MODEL_NAME}_raw_256x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_256x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_256x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_256x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_256x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_320x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_320x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_320x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_320x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_320x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_384x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_384x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_384x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_384x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_384x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_576x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_576x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_576x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_576x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_576x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_384x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_384x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_384x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_384x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_384x256_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_256x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_256x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_256x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_256x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_256x384_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_576x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_576x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_576x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_576x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_576x320_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_320x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_320x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_320x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_320x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_320x576_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_512x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_512x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_512x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_512x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_512x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_768x512_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_768x512_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_768x512_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_768x512_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_768x512_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_raw_768x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_orangemix-vae_768x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_moistmixv2-vae_768x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-1.5_768x768_original_compiled_pruned/Resources/"
    "${MODEL_NAME}_ema-vae-2.1_768x768_original_compiled_pruned/Resources/"
)
new_model_names=(
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

# Perform the model name replacement for all target model names
for (( i=0; i<${#old_model_names[@]}; i++ )); do
    echo "${RED} Cleaning up ${old_model_names[i]}! ${RESET}"
    mv "./${old_model_names[i]}" "./models/${new_model_names[i]}"
done

# Calculate and display the duration of the conversion process
end=$SECONDS
duration=$(( end - start ))

	echo ""
	echo "${GREEN} Conversion of custom resolution original models took $duration seconds to complete ${RESET}"
	echo ""
	sleep 1

# Prompt the user to check that all operations have completed correctly before continuing
echo "${RED}🚨 Removing all work files. Check that all operations have completed correctly before continuing! 🚨${RESET}"
echo "${YELLOW}Press any key to continue, or 's' to stop the script (you have 120 seconds)...${RESET}"
read -n 1 -s -r -t 120 response

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

# Remove the directories and their contents
# Use -f to force deletion without prompting for confirmation
# Use -r to delete the directory and its contents recursively

rm -rf ./${MODEL_NAME}_raw_256x256_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_256x256_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_256x256_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_256x256_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_256x256_original_compiled
rm -rf ./${MODEL_NAME}_raw_320x320_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_320x320_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_320x320_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_320x320_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_320x320_original_compiled
rm -rf ./${MODEL_NAME}_raw_384x384_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_384x384_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_384x384_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_384x384_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_384x384_original_compiled
rm -rf ./${MODEL_NAME}_raw_576x576_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_576x576_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_576x576_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_576x576_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_576x576_original_compiled
rm -rf ./${MODEL_NAME}_raw_384x256_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_384x256_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_384x256_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_384x256_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_384x256_original_compiled
rm -rf ./${MODEL_NAME}_raw_256x384_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_256x384_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_256x384_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_256x384_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_256x384_original_compiled
rm -rf ./${MODEL_NAME}_raw_576x320_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_576x320_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_576x320_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_576x320_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_576x320_original_compiled
rm -rf ./${MODEL_NAME}_raw_320x576_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_320x576_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_320x576_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_320x576_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_320x576_original_compiled
rm -rf ./${MODEL_NAME}_raw_512x768_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_512x768_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_512x768_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_512x768_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_512x768_original_compiled
rm -rf ./${MODEL_NAME}_raw_768x512_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_768x512_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_768x512_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_768x512_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_768x512_original_compiled
rm -rf ./${MODEL_NAME}_raw_768x768_original_compiled
rm -rf ./${MODEL_NAME}_orangemix-vae_768x768_original_compiled
rm -rf ./${MODEL_NAME}_moistmixv2-vae_768x768_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-1.5_768x768_original_compiled
rm -rf ./${MODEL_NAME}_ema-vae-2.1_768x768_original_compiled
rm -rf ./${MODEL_NAME}_raw_256x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_256x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_256x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_256x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_256x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_320x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_320x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_320x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_320x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_320x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_384x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_384x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_384x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_384x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_384x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_576x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_576x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_576x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_576x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_576x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_384x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_384x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_384x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_384x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_384x256_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_256x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_256x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_256x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_256x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_256x384_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_576x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_576x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_576x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_576x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_576x320_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_320x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_320x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_320x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_320x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_320x576_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_512x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_512x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_512x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_512x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_512x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_768x512_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_768x512_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_768x512_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_768x512_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_768x512_original_compiled_pruned
rm -rf ./${MODEL_NAME}_raw_768x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_orangemix-vae_768x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_moistmixv2-vae_768x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-1.5_768x768_original_compiled_pruned
rm -rf ./${MODEL_NAME}_ema-vae-2.1_768x768_original_compiled_pruned