#!/usr/bin/env bash
# Shared functions for install scripts

DRY_RUN="${DRY_RUN:-false}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup"

# Run a command, respecting DRY_RUN mode
run_cmd() {
    if [[ "${DRY_RUN}" == true ]]; then
        echo "[DRY RUN] $*"
        return 0
    fi
    "$@"
}

# Check if a command is available
is_installed() {
    command -v "$1" &>/dev/null
}

# Clone a git repo only if the destination doesn't already exist
clone_if_missing() {
    local url="$1"
    local dest="$2"
    if [[ -d "$dest" ]]; then
        echo "    Already cloned: $dest"
        return 0
    fi
    run_cmd git clone --depth 1 "$url" "$dest"
}

# Backup existing non-symlink files before stowing
backup_existing() {
    local pkg="$1"
    local pkg_dir="$REPO_DIR/$pkg"
    local timestamp
    timestamp="$(date +%Y%m%d-%H%M%S)"
    local backup_path="$BACKUP_DIR/$timestamp"
    local backed_up=false

    while IFS= read -r -d '' file; do
        local rel="${file#"$pkg_dir"/}"
        local target="$HOME/$rel"
        if [[ -e "$target" && ! -L "$target" ]]; then
            if [[ "$backed_up" == false ]]; then
                echo "==> Backing up existing files to $backup_path/"
                backed_up=true
            fi
            local dest_dir
            dest_dir="$(dirname "$backup_path/$rel")"
            mkdir -p "$dest_dir"
            cp -a "$target" "$backup_path/$rel"
            echo "    Backed up: ~/$rel"
        fi
    done < <(find "$pkg_dir" -type f -print0 2>/dev/null)
}

stow_package() {
    local pkg="$1"
    echo "==> Stowing $pkg config..."
    if [[ "${DRY_RUN}" == true ]]; then
        echo "[DRY RUN] stow --dir=$REPO_DIR --target=$HOME $pkg"
        return 0
    fi
    backup_existing "$pkg"
    stow --dir="$REPO_DIR" --target="$HOME" --adopt "$pkg" 2>/dev/null || true
    # --adopt moves existing files into the stow dir; restore repo versions
    (cd "$REPO_DIR" && git checkout -- "$pkg" 2>/dev/null || true)
}

unstow_package() {
    local pkg="$1"
    echo "==> Unstowing $pkg config..."
    if [[ "${DRY_RUN}" == true ]]; then
        echo "[DRY RUN] stow --dir=$REPO_DIR --target=$HOME -D $pkg"
        return 0
    fi
    stow --dir="$REPO_DIR" --target="$HOME" -D "$pkg"
}

setup_ohmyzsh() {
    echo "==> Installing Oh My Zsh..."
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        echo "    Already installed, skipping."
        return 0
    fi
    if [[ "${DRY_RUN}" == true ]]; then
        echo "[DRY RUN] curl + install Oh My Zsh (--unattended)"
        return 0
    fi
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

clone_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local PLUGINS_DIR="$ZSH_CUSTOM/plugins"
    local THEMES_DIR="$ZSH_CUSTOM/themes"
    mkdir -p "$PLUGINS_DIR" "$THEMES_DIR"

    echo "==> Cloning zsh plugins..."
    clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
    clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git "$PLUGINS_DIR/zsh-autosuggestions"
    clone_if_missing https://github.com/zsh-users/zsh-history-substring-search.git "$PLUGINS_DIR/zsh-history-substring-search"
    clone_if_missing https://github.com/MichaelAquilina/zsh-you-should-use.git "$PLUGINS_DIR/you-should-use"

    echo "==> Cloning Powerlevel10k..."
    clone_if_missing https://github.com/romkatv/powerlevel10k.git "$THEMES_DIR/powerlevel10k"
}

setup_zsh() {
    if [[ -f /usr/share/cachyos-zsh-config/cachyos-config.zsh ]]; then
        echo "==> CachyOS detected, skipping Oh My Zsh/plugin install (provided by system)"
    else
        setup_ohmyzsh
        clone_zsh_plugins
    fi
    stow_package zsh

    echo "==> Setting zsh as default shell..."
    run_cmd chsh -s "$(which zsh)"

    echo "==> Done! Restart your terminal."
}

setup_miniconda() {
    local MINICONDA_PATH="$HOME/miniconda3"

    echo "==> Installing Miniconda..."
    if [[ -d "$MINICONDA_PATH" ]]; then
        echo "    Already installed at $MINICONDA_PATH, skipping."
        return 0
    fi
    local INSTALLER="/tmp/Miniconda3-latest-Linux-x86_64.sh"
    run_cmd wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O "$INSTALLER"
    run_cmd bash "$INSTALLER" -b -p "$MINICONDA_PATH"
    run_cmd rm "$INSTALLER"
    run_cmd "$MINICONDA_PATH/bin/conda" init zsh
    echo "    Miniconda installed and initialized."
}

setup_nvim() {
    if is_installed nvim; then
        echo "==> Neovim already installed, skipping build. Re-stowing config..."
        stow_package nvim
        return 0
    fi

    echo "==> Building Neovim from source..."
    local BUILD_DIR="/tmp/neovim-build"
    run_cmd git clone -b release-0.11 --depth 1 https://github.com/neovim/neovim.git "$BUILD_DIR"
    if [[ "${DRY_RUN}" != true ]]; then
        cd "$BUILD_DIR" || exit 1
        run_cmd make CMAKE_BUILD_TYPE=Release
        run_cmd sudo make install
        cd - >/dev/null || exit 1
        rm -rf "$BUILD_DIR"
    else
        echo "[DRY RUN] cd $BUILD_DIR && make CMAKE_BUILD_TYPE=Release && sudo make install"
    fi

    stow_package nvim
}

setup_yay() {
    if is_installed yay; then
        echo "==> yay already installed, skipping."
        return 0
    fi

    echo "==> Installing yay..."
    local BUILD_DIR="/tmp/yay-build"
    run_cmd git clone https://aur.archlinux.org/yay.git "$BUILD_DIR"
    if [[ "${DRY_RUN}" != true ]]; then
        cd "$BUILD_DIR" || exit 1
        run_cmd makepkg -si --noconfirm
        cd - >/dev/null || exit 1
        rm -rf "$BUILD_DIR"
    else
        echo "[DRY RUN] cd $BUILD_DIR && makepkg -si --noconfirm"
    fi
}

setup_tmuxifier() {
    local TMUXIFIER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmuxifier"

    if [[ -d "$TMUXIFIER_DIR" ]]; then
        echo "==> tmuxifier already installed, skipping."
        return 0
    fi

    echo "==> Installing tmuxifier..."
    clone_if_missing https://github.com/jimeh/tmuxifier.git "$TMUXIFIER_DIR"
}
