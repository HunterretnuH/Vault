#!/bin/bash

# --- CONFIGURATION ---
SMB_SERVER="192.168.0.4"
CREDENTIALS_FILE="$HOME/.smb-credentials/truenas-wiki_work"

SHARE_NAME_1="Wiki_DevWiki"
MOUNT_POINT_1="$HOME/mnt/Remote/NAS/Wiki/DevWiki"

SHARE_NAME_2="Wiki_MmanWiki"
MOUNT_POINT_2="$HOME/mnt/Remote/NAS/Wiki/MmanWiki"
# ---------------------

# 1. Check if the server is reachable
echo "Checking connection to SMB server ($SMB_SERVER)..."
if ! ping -c 1 -W 2 "$SMB_SERVER" > /dev/null 2>&1; then
    echo "Error: SMB server ($SMB_SERVER) is unreachable. Are you sure the VPN is on?"
    exit 1
fi

# 2. Verify and parse the credentials file
if [ ! -f "$CREDENTIALS_FILE" ]; then
    echo "Error: Credentials file not found at $CREDENTIALS_FILE"
    exit 1
fi

# Dynamically export credentials from your file
export $(grep -v '^#' "$CREDENTIALS_FILE" | xargs)

# 3. Mount function to avoid code duplication
mount_share() {
    local share="$1"
    local mount_point="$2"

    # Check if already mounted
    if mount | grep -q "$mount_point"; then
        echo "[$share] Already mounted at $mount_point"
    else
        echo "[$share] Mounting to $mount_point..."
        mkdir -p "$mount_point"

        if mount_smbfs "smb://$username:$password@$SMB_SERVER/$share" "$mount_point"; then
            echo "[$share] Success!"
        else
            echo "[$share] Failed to mount."
        fi
    fi
}

# 4. Run the mounts
mount_share "$SHARE_NAME_1" "$MOUNT_POINT_1"
mount_share "$SHARE_NAME_2" "$MOUNT_POINT_2"

# 5. Clear credentials from memory
unset username password
