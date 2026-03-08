#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Updating package list..."
run_cmd sudo apt update

echo "==> Installing dev tools..."
run_cmd sudo apt install -y git build-essential stow fzf ripgrep tmux curl wget
