#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bash "$SCRIPT_DIR/devtools.sh"
bash "$SCRIPT_DIR/zsh.sh"
bash "$SCRIPT_DIR/nvim.sh"
bash "$SCRIPT_DIR/tmux.sh"
bash "$SCRIPT_DIR/sway.sh"
bash "$SCRIPT_DIR/miniconda.sh"
