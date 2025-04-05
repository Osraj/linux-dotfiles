# Fully Automated Zsh Terminal Configuration for Ubuntu (GNOME)

This repository provides a comprehensive, fully automated setup for the Zsh shell on Ubuntu (specifically tailored for the GNOME desktop environment). Run one command, and get a feature-rich terminal ready for development.

## Features

*   **Zsh & Oh My Zsh:** Installs Zsh and the popular Oh My Zsh framework.
*   **Essential Plugins:** Includes `git`, `zsh-syntax-highlighting`, `zsh-autosuggestions`, `web-search`, `zsh-history-substring-search`, and `you-should-use`.
*   **Powerlevel10k Theme:** Installs and automatically configures the Powerlevel10k theme using the settings provided in `p10k.zsh`.
*   **Development Tools:** Installs `build-essential` (common development tools like make, gcc, g++) and **Miniconda** for Python environment management.
*   **Utilities:** Installs `colorls` (beautified `ls`), `neofetch` (system info), `wget`, and `curl`.
*   **GNOME Wallpaper:** Installs `ubuntu-wallpapers` and sets a default background.
*   **Customizations:** Includes custom aliases and keybindings (see `aliasses.sh`, `keybinds.sh`).

## Prerequisites

*   An Ubuntu installation (tested with GNOME desktop environment).
*   Internet connection (for downloading packages and cloning repositories).
*   `sudo` privileges (for installing packages).

## Single-Command Installation

This setup is designed for maximum convenience. Just clone the repository and run the script:

1.  **Clone the repository:**
    Open your terminal (likely Bash initially) and clone this repository:
    ```bash
    git clone <repository_url> ~/zsh-config
    # Replace <repository_url> with the actual URL of this repository
    cd ~/zsh-config
    ```

2.  **Run the Kickstart Script:**
    Execute the script using `bash`:
    ```bash
    bash kickstart.sh
    ```
    The script will perform all necessary steps non-interactively:
    *   Update package lists (`apt update`).
    *   Install all required packages (`zsh`, `git`, `wget`, `curl`, `build-essential`, `ubuntu-wallpapers`, `ruby`, `neofetch`).
    *   Install Oh My Zsh (if not present) and set Zsh as the default shell.
    *   Clone the specified Zsh plugins and the Powerlevel10k theme.
    *   Install the `colorls` Ruby gem.
    *   Download and install Miniconda to `~/miniconda3`.
    *   Initialize Miniconda for Zsh (modifies `~/.zshrc`).
    *   Set a default GNOME desktop wallpaper (`/usr/share/backgrounds/warty-final-ubuntu.png`).
    *   Copy the pre-configured `p10k.zsh` from this repository to `~/.p10k.zsh`.
    *   Backup any existing `~/.zshrc` to `~/.zshrc.pre_config_<timestamp>`.
    *   Append the line to source `zshConfig.sh` to the end of `~/.zshrc`, ensuring it comes *after* Conda's initialization block.

3.  **Close and Reopen Your Terminal:**
    This is crucial for all changes, including the default shell switch to Zsh and environment variables, to take effect.

## Post-Installation Notes

*   **Nerd Fonts:** For Powerlevel10k icons to display correctly, you **must** install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal emulator (e.g., GNOME Terminal, Tilix, Alacritty) to use it. The script cannot do this automatically.
*   **Miniconda:** Miniconda is installed at `~/miniconda3`. The `base` environment will be activated by default in new terminals. You can manage this using `conda config --set auto_activate_base false` if desired.
*   **Customization:** You can further customize aliases (`aliasses.sh`), keybindings (`keybinds.sh`), or the main Zsh settings (`zshConfig.sh`) within this repository's directory. Changes will apply the next time you open a terminal.

## Included Configuration Files

*   `kickstart.sh`: The main installation script.
*   `zshConfig.sh`: Core Zsh settings, sources other files.
*   `p10k.zsh`: Your pre-defined Powerlevel10k configuration.
*   `aliasses.sh`: Custom command aliases.
*   `keybinds.sh`: Custom keybindings.
*   `colorschemes.md`: Suggestions for terminal color schemes.
*   `wallpapersExample.sh`: (No longer used by default setup) An example script for manual wallpaper setting if needed.
