# Set completion cache directories
_zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
_zcompcache="${ZDOTDIR:-$HOME}/.zcompcache"

setopt auto_list # automatically list on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match
setopt auto_param_slash # if completed parameter is a directory, add a trailing slash
setopt extended_glob # needed for file modification glob modifiers in compinit
unsetopt menu_complete # do not autoselect the first completion entry

# use caching to make completion for commands with dynamic completions (e.g. apt) more usable
zstyle ':completion:complete:*' use-cache on
zstyle ':completion:complete:*' cache-path "$_zcompcache"

zstyle ':completion:*' menu select # selection completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

autoload -Uz compinit
_comp_files=($_zcompdump(Nmh-20))
if (( $#_comp_files )); then
  compinit -i -C -d "$_zcompdump"
else 
  compinit -i -d "$_zcompdump"
  # Keep $_zcompdump younger than cache time even if it isn't regenerated.
  touch "$_zcompdump"
fi

# cleanup variables no longer used
unset _cache_dir _comp_files _zcompdump _zcompcache

# DESIRED COMPLETIONS
#
# - docker
# - kubernetes
# - aws
# - bazel
# - home-manager
# - nix
# - exa
# - ripgrep
# - terraform
# - digital ocean
# - node / pnpm
# - go
# - curl
# - rust / cargo
# - git
# - gh
# - postgresql
# - sqlite3
