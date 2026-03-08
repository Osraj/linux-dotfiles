#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing Neovim build dependencies..."
run_cmd sudo pacman -S --needed --noconfirm ninja cmake gettext unzip git curl

setup_nvim
