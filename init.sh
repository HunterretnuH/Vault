#!/usr/bin/env bash

chezmoi_config_dir="$HOME/.config/chezmoi"

function usage () {
    echo "Description:"
    echo "    Hard links appriopriate config/machine/<machine_name>/chezmoi.yaml to ~/.config/chezmoi/chezmoi.yaml."
    echo 
    echo "Usage:"
    echo "    ./init.sh config/machine/<machine_name>"
    echo ""
}

arg1=$1
if [ $# -lt 1 ] || [ "$arg1" == "-h" ]; then
    usage
    exit
fi
machine=$arg1

echo "Hard linking ${machine}/chezmoi.yaml to $chezmoi_config_dir/chezmoi.yaml."
rm -f "$chezmoi_config_dir/chezmoi.yaml"
mkdir -p "$chezmoi_config_dir"
ln "${machine}/chezmoi.yaml" "$chezmoi_config_dir"
echo "Done"
