# TODO: TMUX close all tabs
# TODO: TMUX setup panes initial

# dircolors
# . "${HOME}/.local/share/lscolors.sh"

# set editor to Neovim
export EDITOR="/snap/bin/nvim"
export VISUAL="/snap/bin/nvim"
alias cl='clear'
alias et='exit'
alias nv='nvim'
alias hd='cd $HOME'
alias pd='cd "${HOME}"/Projects'
alias ls='exa'
alias md='mkdir'
alias rd='rm -rf'
alias hub='gh'
alias open='xdg-open'

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

# Python
alias python='python3'
alias py='python3'
export PYTHON='/usr/bin/python3'
export PATH="$PATH:$PYTHON"

# Docker (TODO)
# Node / Yarn (TODO)

# tmux
alias tmux='tmux -2'
alias tk='tmux kill-server'

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

wpconv() {
  folder=$1
  [ ! -d "$folder" ] && echo "Directory for webp conversion does not exist."
  for f in "$folder"/**/*.webp; do
    ffmpeg -i $f ${f%.webp}-w.jpg
    rm $f
    [ ! -f  ${f%.webp}.jpg ] && mv ${f%.webp}-w.jpg ${f%.webp}.jpg
  done
}

alias yup='ncu --upgrade --upgradeAll && yarn upgrade'

### END NVM

### Added by Zinit's installer
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

### End of Zinit's installer chunk

zinit lucid as=command pick="$ZPFX/bin/(fzf|fzf-tmux)" \
    atclone="cp shell/completion.zsh _fzf_completion; \
      cp bin/fzf(|-tmux) $ZPFX/bin" \
    src="shell/key-bindings.zsh" \
    make="PREFIX=$ZPFX install" for \
        junegunn/fzf

zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
 
zinit light asdf-vm/asdf

export PATH="$HOME/.poetry/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
### End of Zinit's installer chunk
