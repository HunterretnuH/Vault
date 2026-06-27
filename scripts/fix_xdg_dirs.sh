#/usr/bin/env bash

echo "Fixing XDG dirs layout"

desktop_dir=/home/$USER/Desktop
media_dir=$desktop_dir/Media

# Move existing XDG directories to new locations (HACK: assummed default XDG dirs paths)
mv /home/$USER/Documents $media_dir
mv /home/$USER/Music $media_dir
mv /home/$USER/Pictures $media_dir
mv /home/$USER/Templates $media_dir
mv /home/$USER/Videos $media_dir

# Create empty directories for not existing XDG dirs
mkdir -p $media_dir/Documents
mkdir -p $media_dir/Music
mkdir -p $media_dir/Pictures
mkdir -p $media_dir/Templates
mkdir -p $media_dir/Videos
mkdir -p $desktop_dir/Scripts
mkdir -p $desktop_dir/Tmp

echo "Done."

