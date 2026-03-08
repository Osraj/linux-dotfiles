#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing Ghostty..."
if is_installed yay; then
    run_cmd yay -S --needed --noconfirm ghostty
else
    run_cmd sudo pacman -S --needed --noconfirm ghostty
fi

stow_package ghostty
