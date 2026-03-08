export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
    git
    zsh-syntax-highlighting
    zsh-autosuggestions
    web-search
    zsh-history-substring-search
    you-should-use
)

source "$ZSH/oh-my-zsh.sh"

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

source "$ZDOTDIR/aliases.sh"
source "$ZDOTDIR/keybinds.sh"
source "$ZDOTDIR/completion.sh"

[[ -f "$ZDOTDIR/wallpapers.sh" ]] && source "$ZDOTDIR/wallpapers.sh"
[[ -f "$ZDOTDIR/.p10k.zsh" ]] && source "$ZDOTDIR/.p10k.zsh"

command -v fastfetch &>/dev/null && fastfetch
