#!/usr/bin/env bash

daemon_name="mnt-Remote-NAS-Media-Family"
echo "Enabling $daemon_name daemon..."
sudo systemctl daemon-reload
sudo systemctl start ${daemon_name}.automount
sudo systemctl enable ${daemon_name}.automount
echo "Done."
