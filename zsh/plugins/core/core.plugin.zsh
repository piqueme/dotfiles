# Command line can be edited in Vi mode
# Toggle mode w/ 'jk' for ease on fingers
bindkey -M viins 'jk' vi-cmd-mode
export KEYTIMEOUT=10

# Use Neovim for default text editing operations.
export EDITOR="/snap/bin/nvim"
export VISUAL="/snap/bin/nvim"
alias nv='nvim'

alias cl='clear'
alias et='exit'
alias hd='cd $HOME'
alias pd='cd "${HOME}"/Projects'
alias ls='exa'
alias md='mkdir'
alias rd='rm -rf'
alias open='xdg-open'
