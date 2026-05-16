#/usr/bin/env bash

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

