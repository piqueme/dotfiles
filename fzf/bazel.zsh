# UTIL
check-in-bazel-workspace() {
  bazel info > /dev/null 2>&1
  if [[ "$?" -ne 0 ]]; then
    echo ""
    local yellow='\033[1;33m'
    echo "${yellow}[ERROR] Cannot search Bazel targets. Not in a Bazel workspace."
    echo ""
    if [[ -n "$ZLE_STATE" ]]; then
      echo ""
    fi
    return 1
  fi
}

fzf-get-bazel-target() {
  local targets target
  targets=$(bazel query "//..." 2>/dev/null) &&
  target=$(echo "$targets" | fzf +m +s) &&
  echo "$target"
}

fzf-get-bazel-build-targets() {
  local targets target
  targets=$(bazel query "//... - tests(//...)" 2>/dev/null) &&
  target=$(echo "$targets" | fzf +m +s) &&
  echo "$target"
}

fzf-get-bazel-test-targets() {
  local targets target
  targets=$(bazel query "tests(//...)" 2>/dev/null) &&
  target=$(echo "$targets" | fzf +m +s) &&
  echo "$target"
}

fzf-get-bazel-package() {
  local packages package
  packages=$(bazel query "//..." --output package 2>/dev/null) &&
  package=$(echo "$packages" | fzf +m +s) &&
  echo "//$package"
}

# FUNCTIONS
fzf-paste-bazel-target() {
  check-in-bazel-workspace &&
  target=$(fzf-get-bazel-target) &&
  BUFFER=$LBUFFER$target $RBUFFER &&
  zle redisplay
  CURSOR=$(($CURSOR + $#target + 2))
}
zle -N fzf-paste-bazel-target
bindkey '^b' fzf-paste-bazel-target

# core
fzf-query-bazel-target-deps() {
  check-in-bazel-workspace &&
  local target=$(fzf-get-bazel-target) &&
  bazel query "deps($target)"
}
# widget
fzf-query-bazel-target-deps-widget() {
  fzf-query-bazel-target-deps &&
  zle reset-prompt
}
# alias
bd() {
  fzf-query-bazel-target-deps
}
zle -N fzf-query-bazel-target-deps-widget
bindkey ';bd' fzf-query-bazel-target-deps-widget

# core
fzf-query-bazel-target-rdeps() {
  check-in-bazel-workspace &&
  local target=$(fzf-get-bazel-target) &&
  bazel query "rdeps("//...", $target)"
}
# widget
fzf-query-bazel-target-rdeps-widget() {
  fzf-query-bazel-target-rdeps &&
  zle reset-prompt
}
# alias
br() {
  fzf-query-bazel-target-rdeps
}
zle -N fzf-query-bazel-target-rdeps-widget
bindkey ';br' fzf-query-bazel-target-rdeps-widget

# core
fzf-build-bazel-target() {
  check-in-bazel-workspace &&
  target=$(fzf-get-bazel-build-targets) &&
  bazel build "$target"
}
# widget
fzf-build-bazel-target-widget() {
  fzf-build-bazel-target &&
  zle reset-prompt
}
# alias
bb() {
  fzf-build-bazel-target
}
zle -N fzf-build-bazel-target-widget
bindkey ';ba' fzf-build-bazel-target-widget

# core
fzf-test-bazel-target() {
  check-in-bazel-workspace &&
  target=$(fzf-get-bazel-test-targets) &&
  bazel test "$target"
}
# widget
fzf-test-bazel-target-widget() {
  fzf-test-bazel-target &&
  zle reset-prompt
}
# alias
bt() {
  fzf-test-bazel-target
}
zle -N fzf-test-bazel-target-widget
bindkey ';bt' fzf-test-bazel-target-widget

# core
fzf-build-bazel-package() {
  check-in-bazel-workspace &&
  package=$(fzf-get-bazel-package) &&
  bazel build "${package}:all"
}
# alias
bbp() {
  fzf-build-bazel-package
}

# core
fzf-test-bazel-package() {
  check-in-bazel-workspace &&
  package=$(fzf-get-bazel-package) &&
  bazel test "${package}:all"
}
# alias
btp() {
  fzf-test-bazel-package
}
