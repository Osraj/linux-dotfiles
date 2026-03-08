#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing tmux..."
run_cmd sudo pacman -S --needed --noconfirm tmux

stow_package tmux
setup_tmuxifier
