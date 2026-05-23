#!/usr/bin/env bash
set -e

# Ensure wget is available before proceeding
command -v wget >/dev/null 2>&1 || (sudo apt-get update && sudo apt-get install -y wget)

# 1. Download and deploy the repository signing key
wget -O- https://deb.tuxedocomputers.com/0x54840598.pub.asc | gpg --dearmor | sudo tee /usr/share/keyrings/tuxedo-archive-keyring.gpg > /dev/null

# 2. Configure the APT source list (overwrites completely on repeat runs)
echo "deb [signed-by=/usr/share/keyrings/tuxedo-archive-keyring.gpg] https://deb.tuxedocomputers.com/ubuntu noble main" | sudo tee /etc/apt/sources.list.d/tuxedo.list > /dev/null

# 3. Apply the strict pinning policy (yt6801 - LAN driver)
sudo tee /etc/apt/preferences.d/tuxedo-pin > /dev/null << 'EOF'
Package: tuxedo-yt6801
Pin: origin deb.tuxedocomputers.com
Pin-Priority: 500

Package: *
Pin: origin deb.tuxedocomputers.com
Pin-Priority: -1
EOF

# 4. Sync package databases and install the LAN driver
sudo apt-get update
sudo apt-get install -y tuxedo-yt6801


