#!/usr/bin/env bash

set -e

PROJECT="$1"
FILE="$2"
LINE="$3"
COL="$4"

# Fallback if not provided
if [ -z "$PROJECT" ]; then
    PROJECT=$(basename "$(pwd)")
fi

SOCKET="/tmp/nvim-vscode-$PROJECT.sock"

server_exist() {
    nvr --servername "$SOCKET" --nostart -s >/dev/null 2>&1
}

# Check if server is alive
if ! server_exist; then
    echo "Starting Neovim server for project: $PROJECT"
    # Run server
    kitty --detach bash -c "nvim --listen $SOCKET"

  # Wait for server to be ready
  sleep 0.1
  for i in {1..50}; do
      if server_exist; then
          break
      fi
      echo "Sleep"
      sleep 0.1
  done
fi

# Open file and focus
nvr --servername "$SOCKET" --remote "$FILE" -c "call cursor($LINE, $COL)" 
