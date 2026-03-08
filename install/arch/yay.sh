#!/usr/bin/env bash
set -euo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/lib.sh"

run_cmd sudo pacman -S --needed --noconfirm base-devel git

setup_yay
