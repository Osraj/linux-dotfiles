#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing Neovim build dependencies..."
run_cmd sudo apt install -y ninja-build gettext cmake unzip curl build-essential git

setup_nvim
