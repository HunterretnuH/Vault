#/usr/bin/env bash

echo "Installing fonts..."
git clone --filter=blob:none --sparse git@github.com:ryanoasis/nerd-fonts
cd nerd-fonts
git sparse-checkout add patched-fonts/JetBrainsMono
find . -name "JetBrainsMonoNerdFont*" | xargs -I {} cp {} ~/.local/share/fonts/
cd ..
rm -rf nerd-fonts
fc-cache -frv
echo "Done."
