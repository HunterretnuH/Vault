#!/usr/bin/env bash 

set -e

echo "Installing apt packages..."
sudo apt install curl keepassxc ripgrep python3 python3-pip python3-pynvim python3-venv npm nodejs trash-cli pv nfs-common cifs-utils
sudo apt install virtualbox-guest-x11
sudo apt install i3 i3blocks rofi picom feh wireguard libreoffice xclip gdb
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

            break
            ;;
        "Single user")
            echo "Starting nix single user installation..."
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
            ;;
esac
done

echo "Deploying chezmoi config..."
# Required to use `nix` command before restarting session
# TODO: Start new bash shell here
nix-shell -p chezmoi
chezmoi init https://github.com/HunterretnuH/Vault
chezmo apply
echo "Done."

echo "Installing default nix profile..."
nix profile add /home/$USER/.config/nix#default
echo "Done."

if [[ "$opt" == "Multi user" ]]; then
    echo "Restricting access to nix to current user..."
    sudo groupadd nix-users
    sudo chgrp nix-users /nix/var/nix/daemon-socket
    sudo chmod ug=rwx,o= /nix/var/nix/daemon-socket
    sudo usermod $USER -aG nix-users
    echo "Done"
fi


echo "Installing other packages (VSCode)..."
vscode_package_name="code_amd64.deb"
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O "$vscode_package_name"
sudo apt install ./"$vscode_package_name"
rm -f ./"$vscode_package_name"
echo "Done."


# TODO: Required changes (experience after reinstalling VM on Ubuntu 24)
# * in case of multi-user install nix profile is not present in /home/$USER until relog (and user also isn't in appriopriate group until relog)
# * udevmon.service - path to udevmon is different when installed from nix (need machine dependant rootmoi service file - solution should be the same as for services -EASY)
# * automate guest additions installation
# * generally I need to get rid of these installtion scripts and integrate all into chezmoi
# * Add vscode extension reinstallation `cat $XDG_CONFIG_HOME/Code/User/extensions.txt | xargs -L 1 code --install-extension`

