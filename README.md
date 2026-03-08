# linux-dotfiles

Modular dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory mirrors the home directory structure and gets symlinked into `~/`. Works from any location on disk.

## Quick Start

```bash
git clone <repo-url> ~/linux-dotfiles   # clone anywhere you like
cd ~/linux-dotfiles

# Interactive installer (recommended) — pick a mode, toggle tools
bash install/run.sh arch

# Install everything non-interactively
bash install/run.sh arch all

# Install a single tool
bash install/run.sh arch zsh
bash install/run.sh arch nvim

# Debian/Ubuntu
bash install/run.sh debian
```

After installing, **restart your terminal**.

### Options

```bash
bash install/run.sh arch --dry-run          # preview without making changes
bash install/run.sh arch --dry-run zsh      # dry-run a single tool
bash install/run.sh arch --remove zsh       # remove symlinks for a tool
```

### Install Modes

| Mode | What's included |
|------|----------------|
| **minimal** | devtools, zsh, nvim, tmux, fonts |
| **work** | minimal + yay, ghostty, vscodium, essential, miniconda |
| **gaming** | minimal + yay, hyprland, ghostty, essential |
| **full** | everything |
| **custom** | pick your own |

## Structure

```
linux-dotfiles/
├── zsh/                        # Shell: Oh My Zsh, Powerlevel10k, vi mode
├── nvim/                       # Editor: lazy.nvim, LSP, Telescope, Treesitter
├── tmux/                       # Multiplexer: Ctrl+A prefix, vi keys
├── hyprland/                   # Wayland compositor + Waybar + Wofi
├── sway/                       # Wayland compositor (i3-compatible)
├── i3/                         # X11 window manager
├── ghostty/                    # Terminal: Rose Pine, Cascadia Mono
├── wezterm/                    # Terminal: Lua config, Rose Pine
├── vscodium/                   # Editor: settings + keybindings
├── install/
│   ├── run.sh                  # Dispatcher: bash install/run.sh <distro> [tool]
│   ├── lib.sh                  # Shared install functions (stow, backup, etc.)
│   ├── menu.sh                 # Interactive TUI menu
│   ├── arch/                   # Arch/CachyOS install scripts
│   └── debian/                 # Debian/Ubuntu install scripts
└── docs/                       # Reference files
```

## Available Install Scripts

**Arch:** all, devtools, yay, fonts, zsh, nvim, tmux, sway, hyprland, i3, ghostty, wezterm, vscodium, essential, miniconda

**Debian:** all, devtools, zsh, nvim, tmux, sway, miniconda

## Manual Stow Usage

Works from any location — no need to `cd` into the repo:

```bash
DOTFILES=~/path/to/linux-dotfiles

stow --dir="$DOTFILES" --target="$HOME" zsh       # Create symlinks
stow --dir="$DOTFILES" --target="$HOME" -D zsh     # Remove symlinks
stow --dir="$DOTFILES" --target="$HOME" -R zsh     # Re-stow
```

## Adding a New Tool

1. Create a directory mirroring the home structure: `tmux/.config/tmux/tmux.conf`
2. Add `install/arch/toolname.sh` — source `lib.sh`, install packages, call `stow_package toolname`
3. Add it to `install/arch/all.sh`

## Requirements

- A [Nerd Font](https://www.nerdfonts.com/) for Powerlevel10k icons
- `stow` (installed automatically by the install scripts)
