source '/usr/share/fzf/key-bindings.zsh'
source '/usr/share/fzf/completion.zsh'

export FZF_DEFAULT_OPTS="--height 40% --border"

fzf-paste-file() {
  local selected
  if selected=$(fd | fzf); then
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file
bindkey '^l' fzf-paste-file

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
