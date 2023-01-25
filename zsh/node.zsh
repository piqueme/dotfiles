lazynvm() {
  unset -f nvm node yarn npm
  export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

yarn() {
  lazynvm
  yarn $@
}

npm() {
  lazynvm
  npm $@
}

export PATH="$PATH:$HOME/.yarn/bin"
