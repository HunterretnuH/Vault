#!/usr/bin/env bash 

{{ if eq .chezmoi.os "linux" -}}
echo "Installing other packages (VSCode)..."
vscode_package_name="code_amd64.deb"
wget 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' -O "$vscode_package_name"
echo "code code/add-microsoft-repo boolean true" | sudo debconf-set-selections
sudo apt install ./"$vscode_package_name"
rm -f ./"$vscode_package_name"
{{ else if eq .chezmoi.os "darwin" -}}
rm -rf "$HOME/Library/Application Support/Code"
ln -s "$HOME/.config/Code" "$HOME/Library/Application Support/Code"
{{ end -}}

echo "Installing VSCode extensions..."
xargs -n 1 code --install-extension < ~/.config/Code/User/extensions.txt
echo "Done."
