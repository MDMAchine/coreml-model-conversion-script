# CoreML model conversion script(s):

Just a few scripts I put together to make converting SD models for [Core ML for use on Apple Silicon devices](https://github.com/apple/ml-stable-diffusion) easier.

Provide the created model(s) to an app such as Mochi Diffusion [Github](https://github.com/godly-devotion/MochiDiffusion) - [Discord](https://discord.gg/x2kartzxGv) to generate images.<br>

This script needs some setup parameters before it can be used.
-ROOT_DIR 		= The location of [ml-stable-diffusion-main](https://github.com/apple/ml-stable-diffusion).
-WORK_DIR 		= The location of these scripts.
-MODELS_LOAD 	= Location of models (ckpt).
-COMPRESSED_DUMP = Location where compressed files are sent.

The initioal setup will ask you to update these parameters.

## Note:

Since this script uses on the fly code insertion and corruption is a possibility. A backup (up to 3) is made for edits of variables and model name.

Start the script by running conversion-script-setup.sh

This script assumes you have an [environment](https://www.infoworld.com/article/3239675/virtualenv-and-venv-python-virtual-environments-explained.html) already set up.
Reference [here](https://github.com/godly-devotion/MochiDiffusion/wiki/How-to-convert-CKPT-or-SafeTensors-files-to-Core-ML) and [here](https://github.com/apple/ml-stable-diffusion#-converting-models-to-core-ml).

This script expects "new_convert_original_stable_diffusion_to_diffusers.py" to be located in root directory. And [diffusers](https://huggingface.co/docs/diffusers/installation) - [Link2](https://pypi.org/project/diffusers/) installed.

Variant selector is rudimentary. If you cant remember whats on and off either look at the files or "reset" it enable all then disable all. After that make other selections.
