SOURCING_PATH="$(pwd)"
RELATIVE_PATH_TO_CONFIG="${funcsourcetrace[1]%/*}"
ABSOSLUTE_PATH_TO_CONFIG="${SOURCING_PATH}/${RELATIVE_PATH_TO_CONFIG}"

#!/bin/bash
# Ensure the script stops if any command fails
set -e

# --- Configuration ---
# Define the absolute path to the directory containing this script and other config files
# Using BASH_SOURCE is more reliable than funcsourcetrace in bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ABSOSLUTE_PATH_TO_CONFIG="$SCRIPT_DIR"
DEFAULT_WALLPAPER="/usr/share/backgrounds/warty-final-ubuntu.png" # A common default wallpaper

# --- Helper Functions ---
print_step() {
    echo "----------------------------------------"
    echo "STEP: $1"
    echo "----------------------------------------"
}

# Helper function to run a command and exit on failure
run_command() {
    echo "Executing: $@"
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Error: Command failed with status $status: $@" >&2
        exit $status
    fi
    return $status
}

# Helper function to run a command but only print a warning on failure
run_command_allow_fail() {
    echo "Executing (allowing failure): $@"
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Warning: Command failed with status $status: $@" >&2
    fi
    return $status
}


# --- Main Script ---
print_step "Updating package list and installing prerequisites"
run_command sudo apt update
run_command sudo apt install -y zsh git wget curl build-essential ubuntu-wallpapers # Added build-essential & ubuntu-wallpapers

print_step "Installing Oh My Zsh (if not present)"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
# Run Oh My Zsh installer non-interactively; it will switch the default shell to zsh
  # Use run_command, but note that the install script itself might handle some errors internally
  run_command sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "Oh My Zsh already installed, skipping installation."
fi

# Define ZSH_CUSTOM (Oh My Zsh custom directory)
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

print_step "Cloning Zsh plugins"
PLUGINS_DIR="${ZSH_CUSTOM}/plugins"
run_command mkdir -p "$PLUGINS_DIR"
run_command_allow_fail git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${PLUGINS_DIR}/zsh-syntax-highlighting"
run_command_allow_fail git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "${PLUGINS_DIR}/zsh-autosuggestions"
run_command_allow_fail git clone --depth 1 https://github.com/zsh-users/zsh-history-substring-search.git "${PLUGINS_DIR}/zsh-history-substring-search"
run_command_allow_fail git clone --depth 1 https://github.com/MichaelAquilina/zsh-you-should-use.git "${PLUGINS_DIR}/you-should-use"

print_step "Cloning Powerlevel10k theme"
THEMES_DIR="${ZSH_CUSTOM}/themes"
run_command mkdir -p "$THEMES_DIR"
run_command_allow_fail git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${THEMES_DIR}/powerlevel10k"

print_step "Installing Ruby and colorls"
run_command sudo apt install -y ruby ruby-rubygems ruby-dev
run_command sudo gem install colorls

print_step "Installing neofetch"
run_command sudo apt install -y neofetch

print_step "Installing Miniconda"
MINICONDA_INSTALL_PATH="$HOME/miniconda3"
if [ ! -d "$MINICONDA_INSTALL_PATH" ]; then
    MINICONDA_SCRIPT="Miniconda3-latest-Linux-x86_64.sh"
    MINICONDA_TMP_PATH="/tmp/${MINICONDA_SCRIPT}"
    run_command wget "https://repo.anaconda.com/miniconda/${MINICONDA_SCRIPT}" -O "$MINICONDA_TMP_PATH"
    run_command bash "$MINICONDA_TMP_PATH" -b -p "$MINICONDA_INSTALL_PATH"
    run_command rm "$MINICONDA_TMP_PATH"
    # Initialize conda for zsh - this will modify .zshrc if it exists, or create it
    run_command "$MINICONDA_INSTALL_PATH/bin/conda" init zsh
    echo "Miniconda installed and initialized for Zsh."
else
    echo "Miniconda already installed at ${MINICONDA_INSTALL_PATH}, skipping installation."
    # Ensure conda is initialized even if already installed
    # Use allow_fail here as init might return non-zero if already initialized correctly,
    # though ideally it should be idempotent. Check conda docs if issues arise.
    run_command_allow_fail "$MINICONDA_INSTALL_PATH/bin/conda" init zsh
fi

print_step "Setting up GNOME Wallpaper"
# Check if gsettings command exists
if command -v gsettings &> /dev/null; then
    # Check if the default wallpaper file exists
    if [ -f "$DEFAULT_WALLPAPER" ]; then
        echo "Setting wallpaper to $DEFAULT_WALLPAPER"
        # Set for both light and dark mode preferences
        # Use allow_fail as gsettings might fail in non-GNOME envs even if command exists
        run_command_allow_fail gsettings set org.gnome.desktop.background picture-uri "file://${DEFAULT_WALLPAPER}"
        run_command_allow_fail gsettings set org.gnome.desktop.background picture-uri-dark "file://${DEFAULT_WALLPAPER}"
    else
        echo "Warning: Default wallpaper $DEFAULT_WALLPAPER not found. Skipping wallpaper setup."
    fi
else
    echo "Warning: 'gsettings' command not found. Cannot set GNOME wallpaper automatically."
fi

print_step "Setting up Powerlevel10k configuration"
run_command cp "${ABSOSLUTE_PATH_TO_CONFIG}/p10k.zsh" "$HOME/.p10k.zsh"

print_step "Configuring .zshrc"
TIME_OF_SCRIPT=$(date +"%Y-%m-%d_%H-%M-%S") # No check needed for date
ZSHRC_FILE="$HOME/.zshrc"
ZSHRC_BACKUP="$HOME/.zshrc.pre_config_${TIME_OF_SCRIPT}"

# Backup existing .zshrc if it exists
if [ -f "$ZSHRC_FILE" ]; then
    echo "Backing up existing $ZSHRC_FILE to $ZSHRC_BACKUP"
    run_command cp "$ZSHRC_FILE" "$ZSHRC_BACKUP"
fi

# Ensure conda initialization is present (it should be from 'conda init zsh')
# Then, append the sourcing of our custom config file *after* conda init
# Use a marker to avoid adding the source line multiple times
CONFIG_SOURCE_LINE="source \"${ABSOSLUTE_PATH_TO_CONFIG}/zshConfig.sh\""
MARKER="# Added by zsh-config kickstart"

if ! grep -qF "$MARKER" "$ZSHRC_FILE"; then
    echo "Appending custom config source to $ZSHRC_FILE"
    # Add a newline just in case the file doesn't end with one
    echo "" >> "$ZSHRC_FILE"
    echo "$MARKER" >> "$ZSHRC_FILE"
    echo "$CONFIG_SOURCE_LINE" >> "$ZSHRC_FILE"
else
    echo "Custom config source line already present in $ZSHRC_FILE."
fi

# --- Final Messages ---
print_step "Kickstart script finished!"
echo "Successfully installed and configured:"
echo "- Zsh, Oh My Zsh, Plugins (Syntax Highlighting, Autosuggestions, etc.)"
echo "- Powerlevel10k Theme (with your provided configuration)"
echo "- build-essential, Ruby, colorls, neofetch"
echo "- Miniconda (installed at $MINICONDA_INSTALL_PATH)"
echo "- Default Ubuntu Wallpaper (for GNOME)"
echo ""
echo "IMPORTANT:"
echo "1. Please CLOSE and REOPEN your terminal for all changes to take effect."
echo "2. Ensure you have a Nerd Font installed and selected in your terminal emulator for Powerlevel10k icons to display correctly."
echo "   Visit: https://www.nerdfonts.com/"
