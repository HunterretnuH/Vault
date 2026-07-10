#!/usr/bin/env bash

echo "Soft linking ~/.remote to ~/Desktop/Remote..."
mkdir -p $HOME/mnt/Remote/NAS/Wiki/DevWiki
mkdir -p $HOME/mnt/Remote/NAS/Wiki/MmanWiki
ln -s $HOME/mnt/Remote $HOME/Desktop/Remote 
echo "Done."

