# This module provides some kick-ass Bazel functionality.
#
# Aliases:
#   bb = bazel build
#   bt = bazel test
#   br = bazel run
#   bd = bazel query deps('<ARGS>')
#   bds = bazel query deps('<ARGS>', 1)
#
# FZF-based Autocompletion:
#   typing ;<Tab> after bazel build/test/run or aliases opens fzf for targets
#   typing ;<Tab> on an option (e.g. "bazel build -;<Tab>") starts fzf for options
#
# FZF target / package helpers:
#   hit <Ctrl-b> to open up a "target" fuzzy-finder anywhere in the workspace
#   hit <Ctrl-o> to open up a "package" fuzzy-finder anywhere in the workspace
#   after selection the target or package will be pasted, helpful for queries

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

_get_bazel_help_option_cmd() {
  local bazel_subcommand=$1
  # NOTE: Ideally we could capture --[no] options as well, but alas...
  help_command="bazel help $bazel_subcommand"
  filter_options_cmd="grep ' --.*'"
  strip_no_options_cmd="sed s/\[\[\]no\[\]\]//g"
  strip_start_spaces_cmd="sed -e 's/^[ \t]*//'"
  strip_parentheses_cmd="sed -e 's/([^()]*)//g'"
  bazel_options_cmd="$help_command | $filter_options_cmd | $strip_no_options_cmd | $strip_start_spaces_cmd | $strip_parentheses_cmd"
  echo "${bazel_options_cmd}"
}

_bazel_fzf_query() {
  if [[ $1 == "test" ]]; then
    echo 'kind(".*_test", "//...")'
  elif [[ $1 == "build" ]]; then
    echo '//...'
  elif [[ $1 == "run" ]]; then
    echo 'kind(".*_bin", "//...")'
  fi
}

_bazel_fzf_alias_map() {
  if [[ $1 == "bb" ]]; then
    echo "build"
  elif [[ $1 == "bt" ]]; then
    echo "test"
  elif [[ $1 == "br" ]]; then
    echo "run"
  fi
}

_bazel_fzf_completer() {
  # the args FZF captures in $@ are not the full prompt
  # we capture the full prompt space-separated here to handle cases
  # like the last fragment being an option (starting with -)
  args=()
  for i in ${=LBUFFER}; do
    args+="$i"
  done

  local bazel_subcommand="$(_bazel_fzf_alias_map ${args[1]})"
  if [[ ${args[-1]} != -* ]] && [[ ! "$@" =~ " -- " ]]; then
    _fzf_complete --multi --reverse --prompt="bazel> " -- "$@" < <(
      bazel query "$(_bazel_fzf_query $bazel_subcommand)" 2>/dev/null
    )
  elif [[ "${args[-1]}" == -* ]] && [[ ! "$@" =~ " -- " ]]; then
    bazel_options_cmd=$(_get_bazel_help_option_cmd "$bazel_subcommand")
    _fzf_complete --multi --reverse --prompt="bazel> " -- "$@" < <(
      eval ${bazel_options_cmd}
    )
    # make sure we have cursor right after completion to help set e.g. string options with =
    CURSOR=$(($CURSOR - 2))
  fi
}

_fzf_complete_bb() {
  _bazel_fzf_completer "$@"
}

_fzf_complete_bt() {
  _bazel_fzf_completer "$@"
}

_fzf_complete_br() {
  _bazel_fzf_completer "$@"
}

_fzf_complete_bazel() {
  # the args FZF captures in $@ are not the full prompt
  # we capture the full prompt space-separated here to handle cases
  # like the last fragment being an option (starting with -)
  args=()
  for i in ${=LBUFFER}; do
    args+="$i"
  done

  if [[ "${args[2]}" == "build" ]] && [[ ${args[-1]} != -* ]] && [[ ! "$@" =~ " -- " ]]; then
    _fzf_complete --multi --reverse --prompt="bazel> " -- "$@" < <(
      bazel query '//...' 2>/dev/null
    )
  elif [[ "${args[2]}" == "test" ]] && [[ ${args[-1]} != -* ]] && [[ ! "$@" =~ " -- " ]]; then
    _fzf_complete --multi --reverse --prompt="bazel> " -- "$@" < <(
      bazel query 'kind(".*_test", "//...")' 2>/dev/null
    )
  elif [[ "${args[2]}" == "run" ]] && [[ ${args[-1]} != -* ]] && [[ ! "$@" =~ " -- " ]]; then
    _fzf_complete --multi --reverse --prompt="bazel> " -- "$@" < <(
      bazel query 'kind(".*_bin", "//...")' 2>/dev/null
    )
  elif [[ "${args[-1]}" == -* ]] && [[ ! "$@" =~ " -- " ]]; then
    bazel_options_cmd=$(_get_bazel_help_option_cmd "${args[2]}")
    _fzf_complete --multi --reverse --prompt="bazel> " -- "$@" < <(
      eval ${bazel_options_cmd}
    )
    # make sure we have cursor right after completion to help set e.g. string options with =
    CURSOR=$(($CURSOR - 2))
  fi
}
