#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing i3..."
run_cmd sudo pacman -S --needed --noconfirm i3-wm i3status dmenu picom brightnessctl

stow_package i3
