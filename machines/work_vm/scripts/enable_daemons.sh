#!/usr/bin/env bash

echo "Enabling automount daemons..."
sudo systemctl daemon-reload
sudo systemctl start mnt-Remote-NAS-Wiki-DevWiki.automount
sudo systemctl enable mnt-Remote-NAS-Wiki-DevWiki.automount
sudo systemctl start mnt-Remote-NAS-Wiki-MmanWiki.automount
sudo systemctl enable mnt-Remote-NAS-Wiki-MmanWiki.automount
echo "Done."
