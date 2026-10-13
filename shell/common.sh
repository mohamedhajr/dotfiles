# Sourced by ~/.zshrc on the Mac and ~/.bashrc on Linux, last, so these win over
# Omarchy's defaults (its `cx` is claude; ours is codex). One set of names everywhere.

# Agents
alias cc='claude --dangerously-skip-permissions'
alias cx='codex --dangerously-bypass-approvals-and-sandbox'

# Tools
alias j='just'
alias h='herdr'

# Option+Left/Right reach the shell as plain Alt+arrows on both machines (Ghostty's
# Mac default turned them into Esc-b/Esc-f; ghostty/config.macos unbinds that so
# herdr can use them for tabs). Linux bash already maps them to word movement
# through Omarchy's inputrc; give zsh the same, in vi and emacs mode alike.
if [ -n "${ZSH_VERSION:-}" ]; then
  for keymap in emacs viins vicmd; do
    bindkey -M "$keymap" '^[[1;3D' backward-word
    bindkey -M "$keymap" '^[[1;3C' forward-word
  done
  unset keymap
fi
