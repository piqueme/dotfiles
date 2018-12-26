# set editor to Neovim
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
alias ls='ls --color=auto'
alias nv='nvim'

### Added by Zplugin's installer
source '/home/obe/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin load zsh-users/zsh-syntax-highlighting
