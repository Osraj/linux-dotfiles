export ZSH="$HOME/.oh-my-zsh"\n
\n
COSTUM_CONFIG_PATH="${funcsourcetrace[1]%/*}/"\n
\n
ZSH_THEME="powerlevel10k/powerlevel10k"\n
\n
plugins=(\n
    git \n
    zsh-syntax-highlighting \n
    zsh-autosuggestions\n
    web-search\n
    zsh-history-substring-search\n
    you-should-use\n
)\n
\n
source $ZSH/oh-my-zsh.sh\n
\n
source ${COSTUM_CONFIG_PATH}aliasses.sh\n
source ${COSTUM_CONFIG_PATH}keybinds.sh\n
\n
source ${COSTUM_CONFIG_PATH}wallpapers.sh\n
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh\n
\n
export PATH="$PATH:/opt/riscv/bin"\n
\n
neofetch
