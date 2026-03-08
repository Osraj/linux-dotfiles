#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing theming packages..."
run_cmd sudo pacman -S --needed --noconfirm kvantum qt5ct

stow_package theming
