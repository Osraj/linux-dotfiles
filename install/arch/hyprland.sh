#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing Hyprland..."
run_cmd sudo pacman -S --needed --noconfirm hyprland wofi waybar hyprpaper xdg-desktop-portal-hyprland \
    mako swaylock-effects wlogout brightnessctl grim slurp wl-clipboard

stow_package hyprland
