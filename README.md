# CoreML model conversion script(s):

Just a few scripts I tied together to make converting SD models for [Core ML for use on Apple Silicon devices](https://github.com/apple/ml-stable-diffusion) easier. Because who doesn't love a good challenge?

They started off as independent items, like those awkward high school students at prom, so there is redundancy & fluff that will maybe get addressed later. But for now, let's just embrace the messiness.

**Provide the created model(s) to an app such as Mochi Diffusion** [Github](https://github.com/godly-devotion/MochiDiffusion) - [Discord](https://discord.gg/x2kartzxGv) **to generate images.** :art:

This script needs some setup parameters before it can be used.

- **ROOT_DIR** 			= The location of [ml-stable-diffusion-main](https://github.com/apple/ml-stable-diffusion).
- **WORK_DIR** 			= The location of these scripts.
- **MODELS_LOAD** 		= Location of models (ckpt).
- **COMPRESSED_DUMP** 	= Location where compressed files are sent.

The initial setup will ask you to update these parameters. Run "conversion-script-start.sh" and select full setup. :rocket:

If there are any issues, the default variable parameters can be changed in "conversion-script-variables.sh" under "# Define the variables". :hammer:

Model name and extension variables can be updated either in the setup script, there is an option in the script selector as well. :gear:

The setup asks if you want to do any updates using pip (see notes). :computer:

Also, there are options for grabbing "convert_original_stable_diffusion_to_diffusers.py" & "torch2coreml_fp32.py" then placing them in locations **for the script to work**. :open_file_folder:

## Version 0.7.6

- Added option to include config file from `yaml` folder while creating diffusers, because who doesn't love a good whiff of YAML in the morning?
- Added memory management options. Don't worry, we won't tell your computer that it's being restricted. We're not even sure it works!
	- First is a 6.7GB limit option. That's like giving a kid a dollar and telling them to make it last a week.
	- Second is 80% of what the system says is available. Because who needs that extra 20%, right?
- Option to clear Diffusers folder. For when you need to sweep the evidence under the rug.

## Version 0.7.5

- 32 bit conversions have **"fp32"** in the filename. 16 bit versions remain unchanged. Because we all know that **16 bits just aren't enough to get the job done**. :computer:

## Version 0.7.4:

- After some testing, it appears that 32-bit models render much slower when generating images. So for now, the default conversion will be for 16-bit (pruned) models unless specified. Who needs speed anyway?
- Pruned model outputs are appended with **'fp16'**. Just in case you needed a reminder that we don't believe in excess. :joy:

## Version 0.7.3:

- Added a simple GUI option for model size and VAE enable/disable. Because why use a command line when you can click on pretty buttons?
- Updated to convert models at fp32. `torch2coreml_fp32.py` can be installed during setup. 32 bits, because we like to live dangerously.
- fp16 is now defined as "pruned". It's like calling a 10-inch pizza a large.

## Version 0.7.2:

- Now you can convert SafeTensors models! Because what's the point of living if you can't live dangerously?
- Added option to enable/disable VAE swap. Just like choosing between Coke and Pepsi, but with less consequence.

## Version 0.7.1:

- Fixed issue with setup script not being able to create a folder if it didn't exist. Who needs folders anyway?

## Version 0.7:

- Added setup script, because typing out all those variables is for chumps.
- Added option to update variables and model name after setup.
- Added option to choose which model type to convert: SafeTensors or ckpt. Why make things easy when they can be complicated?

## Version 0.6:

- First version released into the wild. Rawr.
- Converts ckpt models to Core ML models for use with Mochi Diffusion.

## The Grim README

Welcome to the world of code corruption and variable edits! Before we begin, please note that this script is about as stable as a drunk unicorn riding a unicycle on a tightrope. So, to avoid total disaster, a backup of up to three scripts is made before any meddling occurs.

Next, brace yourself for the VAE script that's so intense it downloads all the necessary files for alternate VAE options. It's like a ninja that anticipates your every move.

To start this crazy ride, just run "conversion-script-setup.sh" and pray that your [virtual environment is already set up](https://www.infoworld.com/article/3239675/virtualenv-and-venv-python-virtual-environments-explained.html) in "ml-stable-diffusion-main." And if not, well, tough luck. But don't worry, [we have some helpful references to help you stumble through it](https://realpython.com/python-virtual-environments-a-primer/). You'll need to get cozy with ["convert_original_stable_diffusion_to_diffusers.py"](https://gist.github.com/saftle/c5e222c6231e7b19f01bb93ac9fcc191/raw/961d49481f472159c0696d929b10647b2c0cc158/replace_vae.py) and [diffusers](https://huggingface.co/docs/diffusers/installation) - [Link2](https://pypi.org/project/diffusers/) installed. And if you're lucky, you'll even find a unicorn that will help you customize your environment. 

Pro tip: Use the "convert_original_stable_diffusion_to_diffusers.py" from the [updated diffusers](https://github.com/huggingface/diffusers). We can't promise it will work, but at least it's not as useless as a chocolate teapot.

Feeling brave? Running the update option in initial setup will let you install/update `diffusers, transformers, accelerate, safetensors, omegaconf, torch, coremltools, scipy, Pillows` along with `python_coreml_stable_diffusion` from local "ml_stable_diffusion." But be warned, this is the unicorn equivalent of walking on hot coals.

You'll also get the chance to download "convert_original_stable_diffusion_to_diffusers.py" and have it placed accordingly. And if you're feeling extra lucky, you can even grab "torch2coreml_fp32.py," the key to running the default 32fp model conversions. 

But wait, there's more! We have rudimentary variant selector(s) that are about as user-friendly as a porcupine at a balloon party. So, if you're feeling confused, just reset it by running enable all, then disable all, and try again. 

And last but not least, if you think you've got everything under control, you can run "conversion-script-selector.sh" instead of the setup script. But don't let your guard down, because this script comes with no guarantee that it will work on any setup. You may need to edit it like a boss to get it to work.

Good luck, brave soul. You're going to need it.
