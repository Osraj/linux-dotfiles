# Powerlevel10k instant prompt (must stay at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# XDG base directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Editor
export EDITOR="nvim"
export VISUAL="nvim"

# History
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# CachyOS system config (provides Oh My Zsh, plugins, p10k theme)
if [[ -f /usr/share/cachyos-zsh-config/cachyos-config.zsh ]]; then
    source /usr/share/cachyos-zsh-config/cachyos-config.zsh
else
    # Fallback for non-CachyOS (standard Oh My Zsh)
    export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
    ZSH_THEME="powerlevel10k/powerlevel10k"
    plugins=(git zsh-syntax-highlighting zsh-autosuggestions zsh-history-substring-search you-should-use)
    [[ -d "$ZSH" ]] && source "$ZSH/oh-my-zsh.sh"
fi

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# Custom config modules
ZSH_CUSTOM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
[[ -f "$ZSH_CUSTOM_DIR/aliases.sh" ]]    && source "$ZSH_CUSTOM_DIR/aliases.sh"
[[ -f "$ZSH_CUSTOM_DIR/keybinds.sh" ]]   && source "$ZSH_CUSTOM_DIR/keybinds.sh"
[[ -f "$ZSH_CUSTOM_DIR/completion.sh" ]]  && source "$ZSH_CUSTOM_DIR/completion.sh"

# Powerlevel10k config
[[ -f "$ZSH_CUSTOM_DIR/.p10k.zsh" ]] && source "$ZSH_CUSTOM_DIR/.p10k.zsh"

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Fastfetch on new shell
command -v fastfetch &>/dev/null && fastfetch
