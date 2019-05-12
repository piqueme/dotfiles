source '/usr/share/fzf/key-bindings.zsh'
source '/usr/share/fzf/completion.zsh'

export FZF_COMPLETION_TRIGGER=""
export FZF_DEFAULT_OPTS="--height 40% --border"

bindkey '^O' fzf-completion
bindkey '^I' $fzf_default_completion

fzf-edit-file-recursive() {
  local filename
  filename=$(fd -Lp -t f | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file
bindkey 'fr' fzf-edit-file

fzf-edit-file-home() {
  local filename
  filename=$(fd -Lp -t f '' $HOME | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file-home
bindkey 'fh' fzf-edit-file-home

fzf-edit-file-git() {
  local gitroot filename
  gitroot=$(git rev-parse --show-toplevel) &&
  filename=$(fd -Lp -t f '' $gitroot | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file-git
bindkey 'fg' fzf-edit-file-git

fzf-change-dir-recursive() {
  local dirname
  dirname=$(fd -Lp -t d | fzf) &&
  cd "$dirname"
  zle reset-prompt
}
zle -N fzf-change-dir
bindkey 'qr' fzf-change-dir

fzf-change-dir-home() {
  local dirname
  dirname=$(fd -Lp -t d '' $HOME | fzf) &&
  cd "$dirname"
  zle reset-prompt
}
zle -N fzf-change-dir-home
bindkey 'qh' fzf-change-dir-home

fzf-change-dir-git() {
  local gitroot dirname
  gitroot=$(git rev-parse --show-toplevel) &&
  dirname=$(fd -Lp -t d '' $dirname | fzf) &&
  cd "$dirname"
  zle reset-prompt
}
zle -N fzf-change-dir-git
bindkey 'qg' fzf-change-dir-git

fzf-paste-file-recursive() {
  local selected
  if selected=$(fd -Lp | fzf); then
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file
bindkey 'pf' fzf-paste-file

fzf-paste-file-home() {
  local selected
  if selected=$(fd -Lp '' $HOME | fzf); then
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file-home
bindkey 'ph' fzf-paste-file-home

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
bindkey 'pg' fzf-paste-file-git

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
bindkey 'gb' fzf-paste-branch-git

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
bindkey 'gh' fzf-paste-commit-git

