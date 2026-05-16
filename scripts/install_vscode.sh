#!/usr/bin/env bash 

echo "Installing other packages (VSCode)..."
vscode_package_name="code_amd64.deb"
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O "$vscode_package_name"
sudo apt install ./"$vscode_package_name"
rm -f ./"$vscode_package_name"
echo "Done."
