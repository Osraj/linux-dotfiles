#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing sway..."
run_cmd sudo apt install -y sway bemenu swaybg mako-notifier wofi

stow_package sway
