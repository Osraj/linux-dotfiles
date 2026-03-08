#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing Alacritty..."
run_cmd sudo pacman -S --needed --noconfirm alacritty

stow_package alacritty
