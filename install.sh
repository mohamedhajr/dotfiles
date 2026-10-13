#!/usr/bin/env bash
# Put this repo's files in place on the machine it runs on. Safe to re-run: a
# link that is already right is left alone, and anything else in the way is
# moved to <name>.bak.<timestamp>, never deleted.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d%H%M%S)"

link() {
  local src="$DOTFILES/$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "ok        $dest"
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mv "$dest" "$dest.bak.$STAMP"
    echo "moved     $dest -> $dest.bak.$STAMP"
  fi
  ln -s "$src" "$dest"
  echo "linked    $dest"
}

# Append a line sourcing shell/common.sh to an rc file, once. It goes last so
# the shared aliases win over anything the rc file sourced before it.
source_from() {
  local rc="$1"
  if [ -f "$rc" ] && grep -qF "$DOTFILES/shell/common.sh" "$rc"; then
    echo "ok        $rc"
    return
  fi
  printf '\n# Shared aliases, same on every machine (~/dotfiles)\n. "%s/shell/common.sh"\n' \
    "$DOTFILES" >>"$rc"
  echo "appended  $rc"
}

link herdr/config.toml "$HOME/.config/herdr/config.toml"

case "$(uname -s)" in
  Darwin)
    link ghostty/config.macos "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    source_from "$HOME/.zshrc"
    "$DOTFILES/macos/defaults.sh"
    echo "applied   macos/defaults.sh"
    ;;
  Linux)
    # Ghostty here is Omarchy's (~/.config/ghostty/config), and so is the rest of
    # the desktop; only the shared pieces are linked.
    source_from "$HOME/.bashrc"
    ;;
esac

if command -v herdr >/dev/null 2>&1; then
  herdr config check
  if herdr server reload-config >/dev/null 2>&1; then
    echo "reloaded  herdr"
  fi
fi
