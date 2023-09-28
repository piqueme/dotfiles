# Source default key-bindings and completion helpers.
if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

export FZF_COMPLETION_TRIGGER=";"
export FZF_DEFAULT_OPTS="--height 40% --border"

# TODO: Wait for this to merge (https://github.com/junegunn/fzf/pull/1299/files)
# This way we can use FZF-based tab-completion only for special commands like bazel.
#
# bindkey '^P' fzf-completion
# bindkey '^I' $fzf_default_completion

fzf-edit-file-recursive() {
  local filename
  filename=$(fd -Lp -t f | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file-recursive
bindkey 'vr' fzf-edit-file-recursive

fzf-edit-file-home() {
  local filename
  filename=$(fd -Lp -t f '' $HOME | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file-home
bindkey 'vh' fzf-edit-file-home

fzf-edit-file-git() {
  local gitroot filename
  gitroot=$(git rev-parse --show-toplevel) &&
  filename=$(fd -Lp -t f '' $gitroot | fzf) &&
  nv "$filename"
  zle reset-prompt
}
zle -N fzf-edit-file-git
bindkey 'vp' fzf-edit-file-git

fzf-change-dir-recursive() {
  local dirname
  dirname=$(fd -Lp -t d | fzf) &&
  cd "$dirname"
  zle reset-prompt
}
zle -N fzf-change-dir-recursive
bindkey 'qr' fzf-change-dir-recursive

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
bindkey 'qp' fzf-change-dir-git

fzf-paste-file-recursive() {
  local selected
  if selected=$(fd -Lp | fzf); then
    selected=$(printf %q "$selected")
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file-recursive
bindkey 'yr' fzf-paste-file-recursive

fzf-paste-file-home() {
  local selected
  if selected=$(fd -Lp '' $HOME | fzf); then
    selected=$(printf %q "$selected")
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file-home
bindkey 'yh' fzf-paste-file-home

fzf-paste-file-git() {
  local selected
  local gitroot
  gitroot=$(git rev-parse --show-toplevel)
  if selected=$(git ls-files $gitroot | fzf); then
    selected=$(printf %q "$selected")
    BUFFER="$LBUFFER$selected $RBUFFER"
  fi
  zle redisplay
  CURSOR=$(($CURSOR + $#selected + 2))
}
zle -N fzf-paste-file-git
bindkey 'yp' fzf-paste-file-git
