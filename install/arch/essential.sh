#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing essential packages..."

if ! is_installed yay; then
    echo "    Error: yay is required. Run 'bash install/run.sh arch yay' first."
    exit 1
fi

run_cmd yay -S --needed --noconfirm \
    base-devel clang gcc gdb llvm rustup \
    python unzip sed grep which \
    brave-bin firefox \
    btop htop fastfetch \
    pipewire pulseaudio pavucontrol playerctl \
    polkit print-manager snapper \
    wofi ncurses5-compat-libs ntfs-3g
