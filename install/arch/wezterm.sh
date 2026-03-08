#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing WezTerm..."
if is_installed yay; then
    run_cmd yay -S --needed --noconfirm wezterm
else
    run_cmd sudo pacman -S --needed --noconfirm wezterm
fi

stow_package wezterm
