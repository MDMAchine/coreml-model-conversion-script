# USAGE:
# python merge_models.py vae.ckpt model.ckpt merged_model

import argparse
import copy
import os
import torch


def merge_models(vae_file_path, model_file_path, new_model_name):
    # Load files
    vae_model = torch.load(vae_file_path, map_location="cpu")
    full_model = torch.load(model_file_path, map_location="cpu")

    # Check for flattened (merged) models
    if 'state_dict' in full_model:
        full_model = full_model["state_dict"]
    if 'state_dict' in vae_model:
        vae_model = vae_model["state_dict"]

    # Replace VAE in model file with new VAE
    vae_dict = {k: v for k, v in vae_model.items() if k[0:4] not in ["loss", "mode"]}
    for k, _ in vae_dict.items():
        key_name = "first_stage_model." + k
        full_model[key_name] = copy.deepcopy(vae_model[k])

    # Get the file extension from the model_file_path and append it to the new model name
    file_extension = os.path.splitext(model_file_path)[1]
    if not new_model_name.endswith(file_extension):
        new_model_name += file_extension

    # Save model with new VAE
    torch.save(full_model, new_model_name)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Merge VAE models into a full model.')
    parser.add_argument('vae_file_path', type=str, help='Path to the VAE file.')
    parser.add_argument('model_file_path', type=str, help='Path to the full model file.')
    parser.add_argument('new_model_name', type=str, nargs='?', default=None, help='Name to use for the new model file.')
    args = parser.parse_args()

    # If new_model_name is not specified, use the input file name with the VAE prefix
    if args.new_model_name is None:
        new_model_name = f"VAE_{os.path.basename(args.model_file_path)}"
    else:
        new_model_name = args.new_model_name

    merge_models(args.vae_file_path, args.model_file_path, new_model_name)
