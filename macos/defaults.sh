#!/usr/bin/env bash
# macOS takes some keys before any terminal sees them. Give back the one the
# shared herdr keymap cannot do without. Run by install.sh; safe to re-run.
set -euo pipefail

# ctrl+space is herdr's prefix. macOS binds it to "Select the previous input
# source" (symbolic hotkey 60). ctrl+option+space ("next source", hotkey 61)
# and the Globe key still switch between ABC and Arabic.
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 \
  '{ enabled = 0; value = { parameters = (32, 49, 262144); type = standard; }; }'

# Left alone on purpose: ctrl+arrows belong to Mission Control (Spaces), so
# herdr's resize mode on prefix+ctrl+arrows works on Linux only.
# ctrl+alt+shift+arrows resizes a pane on both machines.

# Apply without logging out.
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
