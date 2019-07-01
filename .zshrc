# TODO: TMUX close all tabs
# TODO: TMUX setup panes initial

# set editor to Neovim
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
alias ls='ls --color=auto'
alias cl='clear'
alias et='exit'
alias nv='nvim'
alias hd='cd $HOME'
alias pd='cd "${HOME}"/Projects'
alias md='mkdir'
alias rd='rm -rf'

export KEYTIMEOUT=10

# Git aliases
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gbd='git branch -D'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a -m'
alias gcn='git commit --amend'
alias gcan='git commit -a --amend'
alias gd='git diff'
alias gnb='git checkout -b'
alias gch='git checkout'
alias gl='git log --color=always '\''--format=%C(auto)%h%d %C(magenta)%an %C(auto)%s %C(green)%cr'\'''
alias gpl='git pull'
alias gpr='git pull --rebase origin master'
alias gps='git push'
alias gs='git status --short'
gu() {
  cd $(git rev-parse --show-toplevel)
}

# tmux
alias tmux='tmux -2'

# history options
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

setopt auto_cd # navigate without cd
setopt correct_all # autocorrect commands
setopt auto_list # automatically list on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

zstyle ':completion:*' menu select # selection completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

### FZF SETUP
dotfile="$(readlink -f "${(%):-%N}")"
dotdir="$(dirname "$dotfile")"
source "$dotdir/fzf/main.zsh"

### VI MODE
bindkey -M viins 'jk' vi-cmd-mode

### NODE
export PATH="$PATH:$HOME/.yarn/bin"

lazynvm() {
  unset -f nvm node yarn npm
  export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

yarn() {
  lazynvm
  yarn $@
}

npm() {
  lazynvm
  npm $@
}

alias yup='ncu --upgrade --upgradeAll && yarn upgrade'

### END NVM

### Added by Zplugin's installer
source '/home/obe/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin load zsh-users/zsh-syntax-highlighting
zplugin load zsh-users/zsh-autosuggestions
zplugin load zsh-users/zsh-completions

autoload -Uz compinit
compinit
zplugin cdreplay
zmodload -i zsh/complist

### SPACESHIP PROMPT CONFIG
SPACESHIP_PROMPT_ORDER=(
  time          # time stamps
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  node          # Node version
  pyenv         # Pyenv section
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)
SPACESHIP_TIME_SHOW=true
SPACESHIP_PROMPT_ADD_NEWLINE=true
SPACESHIP_CHAR_SYMBOL="❯"
SPACESHIP_CHAR_SUFFIX=" "

zplugin load denysdovhan/spaceship-prompt

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /home/obe/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh ]] && . /home/obe/.config/yarn/global/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /home/obe/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh ]] && . /home/obe/.config/yarn/global/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /home/obe/.config/yarn/global/node_modules/tabtab/.completions/slss.zsh ]] && . /home/obe/.config/yarn/global/node_modules/tabtab/.completions/slss.zsh
