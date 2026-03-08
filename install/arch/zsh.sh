#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing packages..."
run_cmd sudo pacman -S --needed --noconfirm zsh stow fastfetch git wget curl

setup_zsh
