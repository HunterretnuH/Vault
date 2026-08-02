#!/bin/bash

# --- CONFIGURATION ---
MOUNT_POINT_1="$HOME/mnt/Remote/NAS/Wiki/DevWiki"
MOUNT_POINT_2="$HOME/mnt/Remote/NAS/Wiki/MmanWiki"
# ---------------------

# Unmount shares
sudo umount "$MOUNT_POINT_1"
sudo umount "$MOUNT_POINT_2"
