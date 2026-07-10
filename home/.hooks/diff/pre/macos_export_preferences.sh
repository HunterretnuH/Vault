#!/bin/bash

# Stop on errors
set -e

# Dynamically locate the chezmoi source directory
SETTINGS_DIR="$HOME/.config/macos_preferences"

# Ensure target directory exists
mkdir -p "$SETTINGS_DIR"

echo "📥 Exporting current macOS environment settings..."

# 1. Export System Keyboard Shortcuts (XML format via stdout)
defaults export com.apple.symbolichotkeys - > "$SETTINGS_DIR/symbolichotkeys.plist"

# 2. Export Global Application Shortcuts (NeXTSTEP text format)
if defaults read -g NSUserKeyEquivalents >/dev/null 2>&1; then
    defaults read -g NSUserKeyEquivalents > "$SETTINGS_DIR/app_shortcuts.txt"
else
    # Fallback to an empty dictionary block if no shortcuts exist yet
    echo "{}" > "$SETTINGS_DIR/app_shortcuts.txt"
fi

echo "💾 Configuration successfully dumped to $SETTINGS_DIR"
