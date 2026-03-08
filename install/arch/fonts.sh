#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

echo "==> Installing fonts..."
run_cmd sudo pacman -S --needed --noconfirm \
    ttf-fira-mono ttf-fira-sans ttf-fira-code \
    ttf-font-awesome \
    ttf-roboto ttf-roboto-mono ttf-roboto-mono-nerd \
    ttf-cascadia-mono-nerd ttf-cascadia-code-nerd ttf-cascadia-code \
    ttf-sarasa-gothic \
    ttf-noto-nerd \
    ttf-dejavu ttf-dejavu-nerd \
    ttf-hack ttf-hack-nerd \
    gnu-free-fonts ttf-liberation

if is_installed yay; then
    run_cmd yay -S --needed --noconfirm \
        ttf-noto-emoji-monochrome \
        ttf-noto-serif-cjk-vf ttf-noto-serif-vf \
        ttf-noto-sans-cjk-vf ttf-noto-sans-mono-cjk-vf ttf-noto-sans-mono-vf \
        ttf-noto-sans-egyptian-hieroglyphs \
        ttf-ms-fonts
fi
