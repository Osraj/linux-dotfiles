#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

usage() {
    cat <<'EOF'
Usage: bash install/run.sh arch [tool] [options]

Modes:
  bash install/run.sh arch              Interactive menu (default)
  bash install/run.sh arch all          Install everything
  bash install/run.sh arch zsh          Install a single tool

Options:
  --dry-run     Show what would be done without making changes
  --remove      Remove symlinks for a tool (requires tool name)
  --help        Show this help message

Tools: devtools, yay, fonts, zsh, nvim, tmux, sway, hyprland, i3,
       ghostty, wezterm, alacritty, vscodium, theming, essential, miniconda

Examples:
  bash install/run.sh arch                    # interactive menu
  bash install/run.sh arch all                # install everything
  bash install/run.sh arch zsh                # install zsh
  bash install/run.sh arch --dry-run          # interactive dry-run
  bash install/run.sh arch --dry-run zsh      # dry-run single tool
  bash install/run.sh arch --remove zsh       # remove zsh symlinks
EOF
    exit 1
}

# Parse arguments
DISTRO=""
TOOL=""
REMOVE=false
export DRY_RUN="${DRY_RUN:-false}"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            usage
            ;;
        --dry-run)
            export DRY_RUN=true
            shift
            ;;
        --remove)
            REMOVE=true
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            ;;
        *)
            if [[ -z "$DISTRO" ]]; then
                DISTRO="$1"
            elif [[ -z "$TOOL" ]]; then
                TOOL="$1"
            else
                echo "Unexpected argument: $1"
                usage
            fi
            shift
            ;;
    esac
done

[[ -z "$DISTRO" ]] && usage

# Validate distro directory exists
if [[ ! -d "$SCRIPT_DIR/$DISTRO" ]]; then
    echo "Error: Unknown distro '$DISTRO'. Available:"
    for d in "$SCRIPT_DIR"/*/; do
        [[ -d "$d" ]] && echo "  $(basename "$d")"
    done
    exit 1
fi

# Handle --remove
if [[ "$REMOVE" == true ]]; then
    if [[ -z "$TOOL" ]]; then
        echo "Error: --remove requires a tool name (e.g., --remove zsh)"
        exit 1
    fi
    unstow_package "$TOOL"
    exit 0
fi

# No tool specified → interactive menu
if [[ -z "$TOOL" ]]; then
    source "$SCRIPT_DIR/menu.sh"
    run_interactive_menu "$DISTRO"
    exit 0
fi

# Single tool or "all"
TARGET="$SCRIPT_DIR/$DISTRO/$TOOL.sh"

if [[ ! -f "$TARGET" ]]; then
    echo "Error: $TARGET not found"
    usage
fi

echo "Running $DISTRO/$TOOL install..."
bash "$TARGET"
