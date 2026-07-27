#!/bin/sh

OS_TYPE="$(chezmoi execute-template '{{- .chezmoi.os -}}')"
HOOK_DIR="$(chezmoi execute-template '{{- joinPath .chezmoi.sourceDir ".hooks" "diff" "pre" -}}')"
$HOOK_DIR/vscode_extensions_export.sh

if [ "$OS_TYPE" = "darwin" ]; then
$HOOK_DIR/macos_export_preferences.sh
fi
