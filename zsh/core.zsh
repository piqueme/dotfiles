# set editor to Neovim
export EDITOR="/snap/bin/nvim"
export VISUAL="/snap/bin/nvim"
alias nv='nvim'
if which batcat > /dev/null; then
  alias bat='batcat'
fi
alias cl='clear'
alias et='exit'
alias hd='cd $HOME'
alias pd='cd "${HOME}"/Projects'
alias ls='exa'
alias md='mkdir'
alias rd='rm -rf'
alias hub='gh'
alias open='xdg-open'
