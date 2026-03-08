#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Updating package list..."
run_cmd sudo apt update

echo "==> Installing packages..."
run_cmd sudo apt install -y zsh stow fastfetch git wget curl build-essential

setup_zsh
