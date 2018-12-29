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

fzf-paste-branch-git() {
  local branches branch branchname
  # note we use cut to remove the asterisk for current branch
  branches=$(git branch -vv --sort=-committerdate | cut -c 3-) &&
  branch=$(echo "$branches" | fzf +m) &&
  branchname=$(echo "$branch" | awk '{print $1}' | sed "s/.* //") &&
  BUFFER=$LBUFFER$branchname $RBUFFER &&
  zle redisplay &&
  CURSOR=$(($CURSOR + $#branchname + 2))
}
zle -N fzf-paste-branch-git
bindkey 'fb' fzf-paste-branch-git

fzf-paste-commit-git() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit) &&
  commit=$(echo "$commits" | fzf +m +s) &&
  commithash=$(echo "$commit" | awk '{print $1}') &&
  BUFFER=$LBUFFER$commithash $RBUFFER &&
  zle redisplay &&
  CURSOR=$(($CURSOR + $#commithash + 2))
}
zle -N fzf-paste-commit-git
bindkey 'fgh' fzf-paste-commit-git

