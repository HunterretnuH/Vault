#!/usr/bin/env bash

# TODO: Temporarily commmented out - check during next reinstall what is necessary

# echo "Soft linking dual-function-keys and related binaries"
# sudo ln -s /home/$USER/.nix-profile/bin/dual-function-keys /usr/local/bin/dual-function-keys
# sudo ln -s /home/$USER/.nix-profile/bin/udevmon /usr/local/bin/udevmon
# sudo ln -s /home/$USER/.nix-profile/bin/intercept /usr/local/bin/interception
# sudo ln -s /home/$USER/.nix-profile/bin/uinput /usr/local/bin/uinput
# echo "Done."
#
# # Required because I install dual-function-keys as user using nix
# echo "Soft linking $(which dual-function-keys) to /usr/local/bin/dual-function-keys..."
# ln -s $(which dual-function-keys) /usr/local/bin/dual-function-keys
# echo "Done."
