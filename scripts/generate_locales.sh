#!/usr/bin/env bash
set -euo pipefail

# Detect the operating system
OS="$(uname -s)"

if [ "$OS" = "Linux" ]; then
  # List the locales you want to enable
  LOCALES=(
    "en_US.UTF-8 UTF-8"
    "pl_PL.UTF-8 UTF-8"
  )

  LOCALE_GEN="/etc/locale.gen"

  echo "Configuring locales in ${LOCALE_GEN}..."

  for locale in "${LOCALES[@]}"; do
    # Escape special characters for regex
    escaped_locale=$(printf '%s\n' "$locale" | sed 's/[[\.*^$]/\\&/g')
    
    # 1. If it's commented out (# en_US.UTF-8 UTF-8), uncomment it using sudo
    if sudo grep -qE "^#\s*${escaped_locale}" "$LOCALE_GEN"; then
      sudo sed -i -E "s/^#\s*(${escaped_locale})/\1/" "$LOCALE_GEN"
      echo "  Uncommented: $locale"
    # 2. If it's not present at all, append it using sudo tee
    elif ! sudo grep -qE "^${escaped_locale}" "$LOCALE_GEN"; then
      echo "$locale" | sudo tee -a "$LOCALE_GEN" > /dev/null
      echo "  Appended: $locale"
    else
      echo "  Already enabled: $locale"
    fi
  done

  echo "Generating locales..."
  sudo locale-gen

  echo "Done!"
else
  echo "Skipping locale configuration: Not a Linux system (Detected OS: $OS)."
fi
