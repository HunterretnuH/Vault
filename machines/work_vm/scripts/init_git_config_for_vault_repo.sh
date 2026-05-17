#/usr/bin/env bash

cd ~/.local/share/chezmoi
git config user.name "Work"
git config user.e-mail "work@dummy.com"
git remote set-url origin git@git.my-host.org:Hunter/my_vault.git
