#!/usr/bin/env bash

echo "Soft linking ~/.remote to ~/Desktop/Remote..."
sudo mkdir -p /mnt/Remote/NAS/Wiki/DevWiki
sudo mkdir -p /mnt/Remote/NAS/Wiki/MmanWiki
sudo mkdir -p /mnt/Remote/Share-Host
ln -s /mnt/Remote /home/$USER/Desktop/Remote 
export REMOTE_OWNER=$USER
sudo chown -R $REMOTE_OWNER:$REMOTE_OWNER /mnt/Remote
echo "Done."

