                               #!/bin/bash

# Exit on error
set -euo pipefail

APP_NAME="Neovim"
APP_DIR="$HOME/Applications"
APP_PATH="$APP_DIR/$APP_NAME.app"
BUNDLE_ID="com.apple.automator.Neovim"

# 1. Define the correct, native AppleScript source
applescript_source=$(cat << 'EOF'
-- This runs when a file is opened with the app (e.g. via Finder "Open With")
on open theFiles
    set firstFile to item 1 of theFiles
    set myPath to POSIX path of firstFile
    set q to quoted form of myPath
    
    -- Check if Kitty is running
    tell application "System Events"
        set isKittyRunning to (exists (processes where name is "kitty"))
    end tell
    
    tell application "kitty"
        activate
        
        delay 0.5
        
        -- Create a new tab only if Kitty is already running
        if isKittyRunning then
            tell application "System Events"
                keystroke "t" using command down
            end tell
            delay 0.5
        end if
        
        -- Send the keystrokes to Kitty
        tell application "System Events"
            keystroke "nvim " & q
            keystroke return
        end tell
    end tell
end open

-- This runs when you open the app directly (without passing a file)
on run
    tell application "System Events"
        set isKittyRunning to (exists (processes where name is "kitty"))
    end tell
    
    tell application "kitty"
        activate
        
        delay 0.5
        
        if isKittyRunning then
            tell application "System Events"
                keystroke "t" using command down
            end tell
            delay 0.5
        end if
        
        tell application "System Events"
            keystroke "nvim"
            keystroke return
        end tell
    end tell
end run
EOF
)

echo "🔨 Compiling $APP_NAME.app..."
mkdir -p "$APP_DIR"

# Clean up previous build to avoid caching issues
rm -rf "$APP_PATH"

# Compile AppleScript directly to a macOS application bundle
echo "$applescript_source" | osacompile -o "$APP_PATH"

# 2. Assign the Bundle ID to the app's Info.plist
echo "🏷️ Setting Bundle ID to $BUNDLE_ID..."
plutil -replace CFBundleIdentifier -string "$BUNDLE_ID" "$APP_PATH/Contents/Info.plist"

# 3. Declare that this app can accept ALL files
echo "📋 Injecting file handling capabilities into Info.plist..."
plutil -replace CFBundleDocumentTypes -xml "
<array>
    <dict>
        <key>CFBundleTypeExtensions</key>
        <array>
            <string>*</string>
        </array>
        <key>CFBundleTypeName</key>
        <string>All Files</string>
        <key>CFBundleTypeRole</key>
        <string>Viewer</string>
        <key>LSHandlerRank</key>
        <string>Alternate</string>
    </dict>
</array>" "$APP_PATH/Contents/Info.plist"

# --------------------------------------------------------
# 🌟 CRITICAL FIX: Re-sign the app after Info.plist edits!
# --------------------------------------------------------
echo "🔏 Re-signing the app bundle (ad-hoc)..."
codesign --force --deep --sign - "$APP_PATH"

# 4. Force-register the app with the macOS Launch Services database
echo "🔄 Registering app with Launch Services..."
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -f "$APP_PATH"

# 5. Automate file associations with 'duti' (if installed)
if command -v duti &> /dev/null; then
    echo "🔗 Associating default file extensions..."
    for ext in txt md py js ts json sh yaml yml; do
        duti -s "$BUNDLE_ID" "$ext" all
    done
fi

echo "✅ App successfully created and signed at: $APP_PATH"

echo "--------------------------------------------------------"
echo "🔐 one-time manual step required:"
echo "macos prevents command-line automation of accessibility permissions."
echo "i am opening the privacy & security settings pane for you."
echo "please click '+', select: $app_path"
echo "and toggle it on."
echo "--------------------------------------------------------"

# open system settings straight to the accessibility pane
open "x-apple.systempreferences:com.apple.preference.security?privacy_accessibility" 
