# CoreML model conversion script(s):

Just a few scripts I tied together to make converting SD models for [Core ML for use on Apple Silicon devices](https://github.com/apple/ml-stable-diffusion) easier. They started off as independent items so there is redundancy & fluff that will maybe get addressed later.

Provide the created model(s) to an app such as Mochi Diffusion [Github](https://github.com/godly-devotion/MochiDiffusion) - [Discord](https://discord.gg/x2kartzxGv) to generate images.<br>

This script needs some setup parameters before it can be used.
- ROOT_DIR 		= The location of [ml-stable-diffusion-main](https://github.com/apple/ml-stable-diffusion).
- WORK_DIR 		= The location of these scripts.
- MODELS_LOAD 	= Location of models (ckpt).
- COMPRESSED_DUMP = Location where compressed files are sent.

The initial setup ("conversion-script-setup.sh") will ask you to update these parameters.

If there is any issues, the default variable parameters can be changed in "conversion-script-variables.sh" under "# Define the variables".

## Version 07:

- now you can define modelname and extension. This is to incorporate conversion of safetensors as well as ckpt.
- VAE swapping method has changed. Simpler, more reliable.

## Note:

- Since this script uses on the fly code insertion and corruption is a possibility. A backup (up to 3) of the scripts is made before edits of variables and model name are made.

- The VAE script will download the necessary files for use in alternate VAE options.

**Start the script by running "conversion-script-setup.sh"**

This script assumes you have an [environment](https://www.infoworld.com/article/3239675/virtualenv-and-venv-python-virtual-environments-explained.html) already set up. Reference [here](https://github.com/godly-devotion/MochiDiffusion/wiki/How-to-convert-CKPT-or-SafeTensors-files-to-Core-ML) and [here](https://github.com/apple/ml-stable-diffusion#-converting-models-to-core-ml).

This script expects ["convert_original_stable_diffusion_to_diffusers.py"](https://gist.github.com/saftle/c5e222c6231e7b19f01bb93ac9fcc191/raw/961d49481f472159c0696d929b10647b2c0cc158/replace_vae.py) to be located in root directory. And [diffusers](https://huggingface.co/docs/diffusers/installation) - [Link2](https://pypi.org/project/diffusers/) installed.

Preferably use the "convert_original_stable_diffusion_to_diffusers.py" from the [updated diffusers](https://github.com/huggingface/diffusers).

Running the update option in initial setup will run an install/update of:

diffusers, transformers, accelerate, safetensors, omegaconf, torch, coremltools, scipy, along with python_coreml_stable_diffusion from local "ml_stable_diffusion". **Make sure variables are set first!**

You will also get an option to grab "convert_original_stable_diffusion_to_diffusers.py" and have it placed accordingly.

Variant selector is rudimentary. If you cant remember whats on and off, either look at the files or "reset" it by running enable all, then disable all. After that make other selections.

**When no edits are needed you can simply run "conversion-script-selector.sh" instead of the setup script.**
> __Warning__

**No guarantee it runs "as is" on any setup. Editing may be required!**
