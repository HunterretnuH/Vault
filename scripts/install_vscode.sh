#!/usr/bin/env bash 

echo "Installing other packages (VSCode)..."
# TODO: Add check for $(arch) i.e. x86_64 for code_amd64.deb and add at least also ARM
vscode_package_name="code_amd64.deb"
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O "$vscode_package_name"
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt install ./"$vscode_package_name"
rm -f ./"$vscode_package_name"
echo "Done."
