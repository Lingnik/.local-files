export PATH="$PATH:$HOME/.local/bin"
export ZSH_THEME="kafeitu"
export LANG="en_US.UTF-8"
export EDITOR="nvim"

zstyle ':omz:update' mode auto
zstyle ':omz:update' verbose minimal
setopt extended_history

bindkey -s ^f "tmux-sessionizer\n"

alias vim="nvim"
alias vi="nvim"
alias vimdiff="nvim -d"
alias v="nvim"
