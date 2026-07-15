#!/bin/bash

echo "--------------------------------------------------"
echo "Installation complete! Launching apps for setup..."
echo "--------------------------------------------------"

# 1. Launch AeroSpace
if [ -d "/Applications/AeroSpace.app" ]; then
    echo "Starting AeroSpace..."
    open -a "AeroSpace"
else
    echo "⚠️ AeroSpace.app not found in /Applications"
fi

# 2. Launch Karabiner-Elements
if [ -d "/Applications/Karabiner-Elements.app" ]; then
    echo "Starting Karabiner-Elements..."
    open -a "Karabiner-Elements"
else
    echo "⚠️ Karabiner-Elements.app not found in /Applications"
fi


echo -e "\n⚠️ IMPORTANT: After granting permissions to skhd enable service in new terminal window: shkd --start-service"
echo "Done! You can close this terminal."
exit 0
