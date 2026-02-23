#!/usr/bin/env bash


echo "Fixing XDG dirs layout"
desktop_dir=/home/$USER/Desktop
media_dir=$desktop_dir/Media
mkdir $media_dir
mv /home/$USER/Documents $media_dir
mv /home/$USER/Music $media_dir
mv /home/$USER/Pictures $media_dir
mv /home/$USER/Templates $media_dir
mv /home/$USER/Videos $media_dir
mkdir $desktop_dir/Scripts
echo "Done."

echo "Soft linking ~/.remote to ~/Desktop/Remote..."

sudo mkdir -p /mnt/Remote/NAS/Wiki
sudo mkdir -p /mnt/Remote/Host-Share
ln -s /mnt/Remote /home/$USER/Desktop/Remote 
export REMOTE_OWNER=$USER
sudo chown -R $REMOTE_OWNER:$REMOTE_OWNER /mnt/Remote
echo "Done."

echo "Enabling automount daemons..."
sudo systemctl daemon-reload
sudo systemctl start mnt-Remote-NAS-Wiki.automount
sudo systemctl enable mnt-Remote-NAS-Wiki.automount
echo "Done."

echo "Soft linking dual-function-keys"
ln -s /home/$USER/.nix-profile/bin/dual-function-keys /usr/local/bin/dual-function-keys
echo "Done."
