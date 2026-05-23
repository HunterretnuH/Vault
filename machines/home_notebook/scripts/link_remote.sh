#!/usr/bin/env bash

echo "Soft linking ~/.remote to ~/Desktop/Remote..."
sudo umount -f /mnt/Remote/NAS/Media/Family/
sudo mkdir -p  /mnt/Remote/NAS/Media/Family/
sudo umount -f /mnt/Remote/NAS/Media/General/
sudo mkdir -p  /mnt/Remote/NAS/Media/General/
sudo umount -f /mnt/Remote/NAS/Storage/
sudo mkdir -p  /mnt/Remote/NAS/Storage/
sudo umount -f /mnt/Remote/NAS/Wiki
sudo mkdir -p  /mnt/Remote/NAS/Wiki
sudo mkdir -p  /mnt/Remote/Nextcloud
ln -s /mnt/Remote /home/$USER/Desktop/Remote 
echo "Done."
