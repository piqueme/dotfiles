# set editor to Neovim
export EDITOR="/usr/bin/nvim"
export VISUAL="/usr/bin/nvim"
alias ls='ls --color=auto'
alias cl='clear'
alias nv='nvim'

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

### Added by Zplugin's installer
source '/home/obe/.zplugin/bin/zplugin.zsh'
autoload -Uz _zplugin
(( ${+_comps} )) && _comps[zplugin]=_zplugin
### End of Zplugin's installer chunk

zplugin load zsh-users/zsh-syntax-highlighting
zplugin load zsh-users/zsh-autosuggestions
zplugin load zsh-users/zsh-completions
