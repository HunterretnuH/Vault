#/usr/bin/env bash

echo "Installing fonts..."
git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
git sparse-checkout add patched-fonts/JetBrainsMono
mkdir -p $HOME/.local/share/fonts/
find . -name "JetBrainsMonoNerdFont*" | xargs -I {} cp {} ~/.local/share/fonts/
cd ..
rm -rf nerd-fonts
fc-cache -frv
echo "Done."
