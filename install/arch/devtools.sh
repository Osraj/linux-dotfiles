#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing dev tools..."
run_cmd sudo pacman -S --needed --noconfirm git stow fzf ripgrep tmux curl wget
