#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing sway..."
run_cmd sudo pacman -S --needed --noconfirm sway bemenu swaybg mako wofi brightnessctl

stow_package sway
