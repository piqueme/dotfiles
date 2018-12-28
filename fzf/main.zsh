source '/usr/share/fzf/key-bindings.zsh'
source '/usr/share/fzf/completion.zsh'

export FZF_DEFAULT_OPTS="--height 40% --border"

fzf-paste-file() {
  local selected
  if selected=$(fd -Lp | fzf); then
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file
bindkey 'fpf' fzf-paste-file

fzf-paste-file-all() {
  local selected
  if selected=$(fd -LHIp | fzf); then
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file-all
bindkey 'fpa' fzf-paste-file-all

fzf-paste-file-home() {
  local selected
  if selected=$(fd -Lp '' $HOME | fzf); then
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file-home
bindkey 'fph' fzf-paste-file-home

fzf-paste-file-git() {
  local selected
  local gitroot
  gitroot=$(git rev-parse --show-toplevel)
  if selected=$(git ls-files $gitroot | fzf); then
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file-git
bindkey 'fpg' fzf-paste-file-git

# fzf-paste-file-project() {}

# search projects
# search directories
# 	from home
# 	from current
# 	from Git root
# search files
# 	from home
# 	from current
# 	from Git root
# search history
# search Git branches
# search Git history
# process names
# grep
# 	from Git root
# 	current directory
# modules
# 	(e.g. NPM)
# 	(e.g. PyPI)
# 	(e.g. Clojure)
# dictionary?
# 
