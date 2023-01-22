# UTIL
warn() {
  local yellow='\033[1;33m'
  echo "${yellow}[WARN] $@"
}

_check-in-bazel-workspace() {
  bazel info > /dev/null 2>&1
  if [[ "$?" -ne 0 ]]; then
    echo ""
    warn "Cannot search Bazel targets. Not in a Bazel workspace."
    echo ""
    if [[ -n "$ZLE_STATE" ]]; then
      echo ""
    fi
    return 1
  fi
}

_fzf-get-bazel-target() {
  local no_build=false
  local no_test=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no_build)
        no_build=true
        shift
        ;;
      --no_test)
        no_test=true
        shift
        ;;
      *)
        warn "Did not recognize argument $1 for fzf-get-bazel-targets"
        return 1
        ;;
    esac
  done

  local query

  if [[ $no_test == "true" ]] && [[ $no_build == "false" ]]
  then
    query="//... - tests(//...)"
  elif [[ $no_test == "false" ]] && [[ $no_build == "false" ]]
  then
    query="//..."
  elif [[ $no_test == "false" ]] && [[ $no_build == "true" ]]
  then
    query="tests(//...)"
  else
    warn "Cannot ignore both tests and build targets -> empty set"
    return 1
  fi

  local targets target
  targets=$(bazel query "$query" 2>/dev/null) &&
  target=$(echo "$targets" | fzf +m +s) &&
  echo "$target"
}

_fzf-get-bazel-package() {
  local packages package
  packages=$(bazel query "//..." --output package 2>/dev/null) &&
  package=$(echo "$packages" | fzf +m +s) &&
  echo "//$package"
}

# FUNCTIONS
_fzf-paste-bazel-target() {
  _check-in-bazel-workspace &&
  target=$(_fzf-get-bazel-target) &&
  BUFFER=$LBUFFER$target $RBUFFER &&
  zle redisplay
  CURSOR=$(($CURSOR + $#target + 2))
}
zle -N _fzf-paste-bazel-target
bindkey '^b' _fzf-paste-bazel-target

_fzf-paste-bazel-package() {
  _check-in-bazel-workspace &&
  package=$(_fzf-get-bazel-package) &&
  BUFFER=$LBUFFER$package $RBUFFER &&
  zle redisplay
  CURSOR=$(($CURSOR + $#package + 2))
}
zle -N _fzf-paste-bazel-package
bindkey '^o' _fzf-paste-bazel-package

# core
_fzf-build-bazel-target() {
  _check-in-bazel-workspace &&
  target=$(fzf-get-bazel-target --no_test) &&
  bazel build "$target"
}
# widget
_fzf-build-bazel-target-widget() {
  _fzf-build-bazel-target &&
  zle reset-prompt
}
zle -N _fzf-build-bazel-target-widget
bindkey ';be' _fzf-build-bazel-target-widget

# core
_fzf-test-bazel-target() {
  _check-in-bazel-workspace &&
  target=$(_fzf-get-bazel-target --no_build) &&
  bazel test "$target"
}
# widget
_fzf-test-bazel-target-widget() {
  _fzf-test-bazel-target &&
  zle reset-prompt
}
zle -N _fzf-test-bazel-target-widget
bindkey ';bt' _fzf-test-bazel-target-widget

# core
_fzf-test-bazel-package() {
  _check-in-bazel-workspace &&
  package=$(_fzf-get-bazel-package) &&
  bazel test "${package}:all"
}
# widget
_fzf-test-bazel-package-widget() {
  _fzf-test-bazel-package &&
  zle reset-prompt
}
# binding
zle -N _fzf-test-bazel-package-widget
bindkey ';bp' _fzf-test-bazel-package-widget

_bazel-internal-filter() {
  echo "filter(\"^//.*\", $@)"
}
alias bif=_bazel-internal-filter

_bazel-external-filter() {
  echo "filter(\"^[^/].*\", $@)"
}
alias bef=_bazel-external-filter

alias bb="bazel build"
alias bt="bazel test"
alias bq="bazel query"

bqi() {
  local query
  query=$(_bazel-internal-filter "${@}")
  bazel query "$query"
}

bqe() {
  local query
  query=$(_bazel-external-filter "${@}")
  bazel query "$query"
}

bd() {
  bazel query "deps(${@})"
}

bds() {
  bazel query "deps(${@}, 1)"
}

br() {
  bazel query "rdeps(\"//...\", ${@})"
}

brs() {
  bazel query "rdeps(\"//...\", ${@}, 1)"
}
