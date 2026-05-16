#!/usr/bin/env bash

echo "Soft linking dual-function-keys and related binaries"
sudo ln -s /home/$USER/.nix-profile/bin/dual-function-keys /usr/local/bin/dual-function-keys
sudo ln -s /home/$USER/.nix-profile/bin/udevmon /usr/local/bin/udevmon
sudo ln -s /home/$USER/.nix-profile/bin/intercept /usr/local/bin/interception
sudo ln -s /home/$USER/.nix-profile/bin/uinput /usr/local/bin/uinput
echo "Done."
