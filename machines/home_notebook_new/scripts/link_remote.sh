#!/usr/bin/env bash

echo "Soft linking ~/.remote to ~/Desktop/Remote..."
mkdir -p /mnt/Remote/NAS/Media/Family/
mkdir -p /mnt/Remote/NAS/Media/General/
mkdir -p /mnt/Remote/NAS/Storage/
mkdir -p /mnt/Remote/NAS/Wiki
mkdir -p /mnt/Remote/Nextcloud
ln -s /mnt/Remote /home/$USER/Desktop/Remote 
echo "Done."
