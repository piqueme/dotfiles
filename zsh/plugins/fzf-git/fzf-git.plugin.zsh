_warn_deps_do_not_exist() {
  # This warning could be better. Right now it enters into the current
  # command line and requires you to hit "Enter" to get to the next prompt.
  # I probably need to understand ZSH widgets better.
  local yellow='\033[1;33m'
  if ! command -v fzf > /dev/null 2>&1 || ! command -v git > /dev/null 2>&1; then
    echo "${yellow}fzf or git not available. Cannot run fzf-git."
    return 1
  fi
  return 0
}

_parse_branch_from_git() {
  local branchname
  branchname=$(echo "$1" | awk '{print $1}' | sed 's/.* //')
  echo "$branchname"
}

_fzf_branches() {
  local branches lines key branch branchname

  if ! _warn_deps_do_not_exist; then
    return 1 
  fi

  # NOTE: We use cut to remove the asterisk for the current branch.
  branches=$(git branch -vv --sort=-committerdate | cut -c 3-) &&
  lines=$(fzf --expect=ctrl-d,ctrl-v,ctrl-s,ctrl-o,ctrl-x <<< "$branches") &&
  key="$(head -1 <<< "$lines")"
  branch="$(sed 1d <<< "$lines")"
  branchname="$(_parse_branch_from_git "$branch")"

  case "$key" in
    ctrl-d)
      # Open a diff of the branch with the diff tool of choice.
      git difftool "$branchname"
      zle reset-prompt
      ;;
    ctrl-v)
      # Get a patch output for the diff with the selected and current branch.
      git diff --patch "$branchname"
      zle reset-prompt
      ;;
    ctrl-s)
      # Get a summary (stat) output for the diff with the selected and current branch.
      # Potentially move this to a preview. Deprioritized due to cost of generating the preview.
      git diff --stat "$branchname"
      zle reset-prompt
      ;;
    ctrl-o)
      # Checkout the selected branch.
      git checkout "$branchname"
      zle reset-prompt
      ;;
    ctrl-x)
      # Delete the selected branch.
      git branch --delete "$branchname"
      zle reset-prompt
      ;;
    *)
      # Default (enter) = paste the branch name at the end of the current prompt.
      BUFFER=$LBUFFER$branchname $RBUFFER &&
      zle redisplay &&
      CURSOR=$(($CURSOR + $#branchname + 2))
      ;;
  esac
}

_commit_pretty_format() {
  # NOTE: Unfortunately colors are not preserved by fzf, unclear to me why as of yet.
  echo "%Cred%h %Creset%s %Cblue%aE %Cgreen%ar%Creset"
}

_parse_hash_from_pretty_format() {
  echo $(echo $1 | awk '{print $1}')
}

_fzf_commits() {
  local commits lines key commit commithash logformat
  logformat=$(_commit_pretty_format)

  if ! _warn_deps_do_not_exist; then
    return 1 
  fi

  # NOTE: We use cut to remove the asterisk for the current branch.
  commits=$(git log --pretty=format:"$logformat") &&
  lines=$(fzf --expect=ctrl-d,ctrl-v,ctrl-s,ctrl-o,ctrl-r,ctrl-u <<< "$commits") &&
  key="$(head -1 <<< "$lines")"
  commit="$(sed 1d <<< "$lines")"
  commithash="$(_parse_hash_from_pretty_format "$commit")"

  case "$key" in
    ctrl-d)
      # Open a diff of the commit with the diff tool of choice.
      git difftool "$commithash"
      zle reset-prompt
      ;;
    ctrl-v)
      # Get a patch output for the diff with the selected and current commit.
      git diff --patch "$commithash"
      zle reset-prompt
      ;;
    ctrl-s)
      # Get a summary (stat) output for the diff with the selected and current commit.
      # Potentially move this to a preview. Deprioritized due to cost of generating the preview.
      git diff --stat "$commithash"
      zle reset-prompt
      ;;
    ctrl-o)
      # Checkout the selected commit.
      git checkout "$commithash"
      zle reset-prompt
      ;;
    ctrl-r)
      # Soft reset to the selected commit. Helpful for squashing commits.
      git reset --soft "$commithash"
      zle reset-prompt
      ;;
    ctrl-u)
      # Hard reset to the selected commit. Useful for wiping changes on current branch.
      git reset --hard "$commithash"
      zle reset-prompt
      ;;
    *)
      # Default (enter) = paste the commit hash at the end of the current prompt.
      BUFFER=$LBUFFER$commithash $RBUFFER &&
      zle redisplay &&
      CURSOR=$(($CURSOR + $#commithash + 2))
      ;;
  esac
}

# Register ZLE widgets.
zle -N _fzf_branches
zle -N _fzf_commits

# Register keybindings.
bindkey ';b' _fzf_branches
bindkey ';h' _fzf_commits
