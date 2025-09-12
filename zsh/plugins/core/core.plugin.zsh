# Command line can be edited in Vi mode
# Toggle mode w/ 'jk' for ease on fingers
bindkey -M viins 'jn' vi-cmd-mode
export KEYTIMEOUT=10

# Use Neovim for default text editing operations.
export EDITOR="$(which nvim)"
export VISUAL="$(which nvim)"
alias nv='nvim'

alias cl='clear'
alias et='exit'
alias hd='cd $HOME'
alias pd='cd "${HOME}"/Projects'
alias ls='eza'
alias md='mkdir'
alias rd='rm -rf'
alias open='xdg-open'

# bat diff with context
# exa tree w/ icons
# exa list w/ icons
