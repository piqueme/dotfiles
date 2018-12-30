source '/usr/share/fzf/key-bindings.zsh'
source '/usr/share/fzf/completion.zsh'

export FZF_DEFAULT_OPTS="--height 40% --border"

fzf-edit-file() {
  local filename
  filename=$(fd -Lp -t f | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file
bindkey 'fef' fzf-edit-file

fzf-edit-file-home() {
  local filename
  filename=$(fd -Lp -t f '' $HOME | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file-home
bindkey 'feh' fzf-edit-file-home

fzf-edit-file-git() {
  local gitroot filename
  gitroot=$(git rev-parse --show-toplevel) &&
  filename=$(fd -Lp -t f '' $gitroot | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file-git
bindkey 'feg' fzf-edit-file-git

fzf-change-dir() {
  local dirname
  dirname=$(fd -Lp -t d | fzf) &&
  cd "$dirname"
  zle reset-prompt
}
zle -N fzf-change-dir
bindkey 'fsr' fzf-change-dir

fzf-change-dir-home() {
  local dirname
  dirname=$(fd -Lp -t d '' $HOME | fzf) &&
  cd "$dirname"
  zle reset-prompt
}
zle -N fzf-change-dir-home
bindkey 'fsh' fzf-change-dir-home

fzf-change-dir-git() {
  local gitroot dirname
  gitroot=$(git rev-parse --show-toplevel) &&
  dirname=$(fd -Lp -t d '' $dirname | fzf) &&
  cd "$dirname"
  zle reset-prompt
}
zle -N fzf-change-dir-git
bindkey 'fsg' fzf-change-dir-git

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

