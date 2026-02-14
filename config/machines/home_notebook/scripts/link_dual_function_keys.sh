#!/usr/bin/env bash

# Required because I install dual-function-keys as user using nix
echo "Soft linking $(which dual-function-keys) to /usr/local/bin/dual-function-keys..."
ln -s $(which dual-function-keys) /usr/local/bin/dual-function-keys
echo "Done."
