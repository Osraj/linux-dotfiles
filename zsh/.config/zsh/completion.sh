zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"
mkdir -p "$XDG_CACHE_HOME/zsh"
