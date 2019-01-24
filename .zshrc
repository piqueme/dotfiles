# set editor to Neovim
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
alias ls='ls --color=auto'
alias cl='clear'
alias et='exit'
alias nv='nvim'
alias hd='cd $HOME'
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
alias gnb='git checkout -b'
alias gch='git checkout'
alias gl='git log --color=always '\''--format=%C(auto)%h%d %s %C(green)%cr'\'''
alias gpl='git pull'
alias gpr='git pull --rebase origin master'
alias gps='git push'
alias gs='git status --short'
gd() {
  cd $(git rev-parse --show-toplevel)
}

# tmux
alias tmux='tmux -2'

### Autocompletion
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi
zmodload -i zsh/complist

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

### NVM
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
### END NVM

### Added by Zplugin's installer
source '/home/obe/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin load zsh-users/zsh-syntax-highlighting
zplugin load zsh-users/zsh-autosuggestions
zplugin load zsh-users/zsh-completions

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
