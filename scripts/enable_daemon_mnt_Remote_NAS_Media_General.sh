#!/usr/bin/env bash

daemon_name="mnt-Remote-NAS-Media-General"
echo "Enabling $daemon_name daemon..."
sudo systemctl daemon-reload
sudo systemctl start ${daemon_name}.automount
sudo systemctl start ${daemon_name}.mount
sudo systemctl enable ${daemon_name}.mount
sudo systemctl enable ${daemon_name}.automount
echo "Done."
