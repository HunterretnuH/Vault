#!/usr/bin/env bash

set -e

echo "Installing apt packages..."
sudo apt install chezmoi wl-clipboard keepassxc ripgrep python3 python3-pip npm nodejs gThumb trash-cli easyeffects pv interception-tools nfs-common cifs-utils
echo "Done."

echo "Installing nix..."

PS3="Select type or skip nix installation:"
select opt in "Multi user" "Single user" "Skip"
do
    case $opt in
        "Multi user")
            echo "Starting nix multi user installation..."
            sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
            echo "Done"

            echo "Restricting access to nix to current user..."
            sudo groupadd nix-users
            sudo chgrp nix-users /nix/var/nix/daemon-socket
            sudo chmod ug=rwx,o= /nix/var/nix/daemon-socket
            sudo usermod $USER -aG nix-users
            echo "Done"

            break
            ;;
        "Single user")
            echo "Starting nix multi user installation..."
            sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --no-daemon
            echo "Done"
            echo "See https://nix.dev/manual/nix/2.28/installation/single-user and optionally run:"
            echo "sudo chown $USER:$USER prefix/var/nix/db"
            echo "sudo chown $USER:$USER prefix/store"

            break
            ;;
        "Skip")
            echo "Skipping nix installation."
            break
            ;;
        *) echo "Invalid option: $REPLY"
done

echo "Installing default nix profile..."
nix profile add .config/nix#default
echo "Done."

