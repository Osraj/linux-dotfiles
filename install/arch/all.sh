#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/devtools.sh"
bash "$SCRIPT_DIR/zsh.sh"
bash "$SCRIPT_DIR/yay.sh"
bash "$SCRIPT_DIR/fonts.sh"
bash "$SCRIPT_DIR/nvim.sh"
bash "$SCRIPT_DIR/tmux.sh"
bash "$SCRIPT_DIR/sway.sh"
bash "$SCRIPT_DIR/hyprland.sh"
bash "$SCRIPT_DIR/i3.sh"
bash "$SCRIPT_DIR/ghostty.sh"
bash "$SCRIPT_DIR/wezterm.sh"
bash "$SCRIPT_DIR/alacritty.sh"
bash "$SCRIPT_DIR/vscodium.sh"
bash "$SCRIPT_DIR/theming.sh"
bash "$SCRIPT_DIR/essential.sh"
bash "$SCRIPT_DIR/miniconda.sh"
