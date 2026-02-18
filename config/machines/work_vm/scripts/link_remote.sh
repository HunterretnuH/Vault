#!/usr/bin/env bash

echo "Soft linking ~/.remote to ~/Desktop/Remote..."
mkdir -p /mnt/Remote/NAS/Wiki
ln -s /mnt/Remote /home/$USER/Desktop/Remote 
echo "Done."
