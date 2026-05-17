#!/usr/bin/env bash

src_dir=~/.local/src

mkdir -p $src_dir
cd $src_dir
git clone https://gitlab.com/tuxedocomputers/development/packages/tuxedo-yt6801
cd tuxedo-yt6801
sudo apt install devscripts debhelper dh-dkms
debuild -us -uc # Skips signing which is default, because packages are usually uploaded to server
sudo apt install ./tuxedo-yt6801_1.0.30tux5_all.deb



