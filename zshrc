# General
export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
DOTFILE="$(readlink -f "${(%):-%N}")"
DOTDIR="$(dirname "$DOTFILE")"

# set VI Mode
bindkey -M viins 'jk' vi-cmd-mode
export KEYTIMEOUT=10

# basic utilities (e.g. exa)
source "$DOTDIR/zsh/core.zsh"
source "$DOTDIR/zsh/tmux.zsh"
source "$DOTDIR/zsh/git.zsh"

# Languages
source "$DOTDIR/zsh/go.zsh"
source "$DOTDIR/zsh/python.zsh"
source "$DOTDIR/zsh/node.zsh"

# ZSH-focus
source "$DOTDIR/zsh/history.zsh"
source "$DOTDIR/zsh/completion.zsh"

# fzf
source "$DOTDIR/fzf/theme.zsh"
source "$DOTDIR/fzf/main.zsh"
source "$DOTDIR/fzf/bazel.zsh"

# Docker (TODO)
# Kubernetes (TODO)

### Added by Zinit's installer
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
mkdir -p "$(dirname $ZINIT_HOME)"
# install zinit if not yet available
if [[ ! -d "$(dirname $ZINIT_HOME)" ]]; then
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Add zinit completions
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# INSTALL FZF AS ZSH PLUGIN
zinit lucid as=command pick="bin/(fzf|fzf-tmux)" \
    atclone="cp shell/completion.zsh _fzf_completion; \
      cp bin/fzf(|-tmux) $ZPFX/bin" \
    multisrc="shell/key-bindings.zsh shell/completion.zsh" \
    make="PREFIX=$ZPFX install" for \
        junegunn/fzf

# PROMPT
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions
 
# LANGUAGE RUNTIME MANAGER
zinit light asdf-vm/asdf
