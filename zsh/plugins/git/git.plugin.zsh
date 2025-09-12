alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gbd='git branch -D'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit -a -m'
alias gcn='git commit --amend'
alias gcan='git commit -a --amend'
alias gd='git diff'
alias gnb='git checkout -b'
alias gch='git checkout'
alias gl='git log --color=always '\''--format=%C(auto)%h%d %C(magenta)%an %C(auto)%s %C(green)%cr'\'''
alias gpl='git pull'
alias gpr='git pull --rebase origin master'
alias gps='git push'
alias gs='git status --short'
gu() {
  cd $(git rev-parse --show-toplevel)
}

# alias hub to gh (avoid conflict with gh FZF helper
alias hub='gh'
