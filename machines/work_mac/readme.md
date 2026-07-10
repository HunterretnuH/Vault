echo "⚠️  MANUAL ACTION REQUIRED ⚠️"
echo "Please ensure the following apps are enabled in System Settings:"
echo " - AeroSpace (Accessibility)"
echo " - Karabiner-Core-Service (Accessibility)"
echo " - Add Custom Neovim Application (Accessibility)"
echo ""

# Automatically open the Privacy & Security panes to save yourself clicking around
echo " -> Opening Privacy & Security settings..."
open "x-apple.systempreferences:com.apple.preference.security?Privacy"


echo " - General->Login Items & Extensions"
echo " - App Background Activity:"
echo " - Karabiner-Elements Non-Privilidget Agents v2"
echo " - Karabiner-Elements Privilidget Daemons v2"
