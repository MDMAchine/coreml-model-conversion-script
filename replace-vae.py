# USAGE:
# python merge_models.py path/to/vae_file.pt path/to/model_file.ckpt new_model_name.ckpt


import argparse
import copy
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

    # Save model with new VAE
    torch.save(full_model, new_model_name)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Merge VAE models into a full model.')
    parser.add_argument('vae_file_path', type=str, help='Path to the VAE file.')
    parser.add_argument('model_file_path', type=str, help='Path to the full model file.')
    parser.add_argument('new_model_name', type=str, help='Name to use for the new model file.')
    args = parser.parse_args()

    merge_models(args.vae_file_path, args.model_file_path, args.new_model_name)
