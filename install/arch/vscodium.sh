#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing VSCodium..."
if is_installed yay; then
    run_cmd yay -S --needed --noconfirm vscodium-bin
else
    echo "    yay required for vscodium-bin (AUR). Skipping install."
    echo "    Stowing config only..."
fi

stow_package vscodium
