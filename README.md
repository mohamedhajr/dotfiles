# dotfiles

One herdr keymap and one set of aliases on the Mac and on the Linux box (Omarchy).

```sh
gh repo clone mohamedhajr/dotfiles ~/dotfiles && ~/dotfiles/install.sh
```

`install.sh` is safe to re-run. Anything already in the way is moved to `<name>.bak.<timestamp>`.

| File | Goes to | Machine |
|---|---|---|
| `herdr/config.toml` | `~/.config/herdr/config.toml` (symlink) | both |
| `shell/common.sh` | sourced at the end of `~/.zshrc` / `~/.bashrc` | both |
| `ghostty/config.macos` | `~/Library/Application Support/com.mitchellh.ghostty/config` (symlink) | Mac |
| `macos/defaults.sh` | run by `install.sh` | Mac |

herdr writes through the symlink (e.g. `onboarding = false`), so a change made from
inside herdr shows up here as a diff to commit.

## The rule

The herdr config is the same file everywhere. When a key does not reach herdr on one
OS, fix it underneath, in the terminal or the OS settings, never by forking the
keymap.

## What the Mac needs, and why

| Key | Problem on macOS | Fix |
|---|---|---|
| `ctrl+space` (herdr prefix) | "Select the previous input source" | turned off in `macos/defaults.sh`; switch layouts with `ctrl+option+space` or Globe |
| `alt+…` | Option types special characters on the ABC layout | `macos-option-as-alt = left` in Ghostty; right Option still types them |
| `alt+←/→` (previous/next tab) | Ghostty sends them as Esc-b/Esc-f | unbound in Ghostty; outside herdr, `shell/common.sh` maps them to word movement in zsh |
| `alt+shift+enter` (vertical split) | indistinguishable from `alt+enter` | sent as CSI-u, as Omarchy's Ghostty does |
| `prefix+ctrl+arrows` (resize mode) | Mission Control owns `ctrl+arrows` | not fixed: Linux only. `ctrl+alt+shift+arrows` resizes on both |

## Not here, on purpose

- `~/.zshrc`, `~/.bashrc`: machine-specific paths and private values. They source `shell/common.sh`.
- Linux Ghostty: Omarchy owns `~/.config/ghostty/config`.
- herdr itself: Homebrew on the Mac, Omarchy's package on Linux. The config passes `herdr config check` on both versions.
