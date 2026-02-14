#!/usr/bin/env bash

chezmoi_config_dir="$HOME/.config/chezmoi"

function usage () {
    echo "Description:"
    echo "    Hard links appriopriate config/machine/<machine_name>/chezmoi.toml to ~/.config/chezmoi/chezmoi.toml."
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

echo "Hard linking ${machine}/chezmoi.toml to $chezmoi_config_dir/chezmoi.toml."
rm "$chezmoi_config_dir/chezmoi.toml"
mkdir -p "$chezmoi_config_dir"
ln "${machine}/chezmoi.toml" "$chezmoi_config_dir"
echo "Done"
