#!/bin/bash
set -e

# Home Configuration Script for Ubuntu
# Translated from home.nix

echo "Starting home configuration for user $(whoami)..."

# Define directories
DOTDIR="$HOME/dotfiles"  # Adjust this path to where you'll store your dotfiles
ZDOTDIR="$DOTDIR/zsh"

# Create necessary directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.cache"
mkdir -p "$HOME/.local/bin"

# ===== Package Installation =====
echo "Installing packages..."

# Add necessary repositories
sudo apt update
sudo apt install -y software-properties-common apt-transport-https curl wget gnupg

# Install Mise, nicer for dev tool management
curl https://mise.run | sh

# Add mise to your shell
echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc

# TODO: Switch to using a lockfile from mise
mise use --global node@latest
mise use --global neovim@stable
mise use --global jq@latest
mise use --global fzf@latest
mise use --global ripgrep@latest
mise use --global fd@latest
mise use --global bat@latest
mise use --global eza@latest
mise use --global zoxide@latest
mise use --global yazi@latest
mise use --global delta@latest
mise use --global jj@latest
mise use --global github-cli@latest

# Install programming languages with mise
mise use --global golang@1.24.6
mise use --global python@3.13
mise use --global rust@stable
mise use --global bazel@7.6.1

# Install packages from apt
sudo apt update
sudo apt install -y \
  sqlite3 \
  gcc \
  make \
  syncthing

# ===== Dotfiles Setup =====
echo "Setting up dotfiles..."

# Clone your dotfiles repository if it doesn't exist
if [ ! -d "$DOTDIR" ]; then
  echo "Please enter your dotfiles repository URL (or press Enter to skip):"
  read DOTFILES_REPO
  if [ -n "$DOTFILES_REPO" ]; then
    git clone "$DOTFILES_REPO" "$DOTDIR"
  else
    mkdir -p "$DOTDIR"
    mkdir -p "$ZDOTDIR/plugins"
    mkdir -p "$ZDOTDIR/functions"
  fi
fi

# ===== ZSH Setup =====
echo "Setting up ZSH..."

# Install ZSH if not already installed
sudo apt install -y zsh

# Set ZSH as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s $(which zsh)
fi

# Install Antidote (ZSH plugin manager)
if [ ! -d "$HOME/.antidote" ]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi

# Create .zshrc
cat > "$HOME/.zshrc" << 'EOF'
# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Load antidote
source "$HOME/.antidote/antidote.zsh"

# Initialize antidote
antidote load

# Load Powerlevel10k configuration
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Initialize zoxide
eval "$(zoxide init zsh)"

# Aliases
alias ls='eza --color=auto'
alias ll='eza -la'
alias cat='bat'
alias find='fd'
alias grep='rg'

# Initialize direnv
eval "$(direnv hook zsh)"
EOF

# Create .zsh_plugins.txt for antidote
cat > "$HOME/.zsh_plugins.txt" << EOF
# ZSH Prompt Plugin
romkatv/powerlevel10k

# ZSH Profiling tool
romkatv/zsh-bench kind:path

# Standard shell helpers
zdharma-continuum/fast-syntax-highlighting kind:defer
zsh-users/zsh-autosuggestions kind:defer
zsh-users/zsh-completions kind:fpath path:src

# Personal plugins - uncomment these once you've set up your dotfiles
# ${ZDOTDIR}/plugins/core
# ${ZDOTDIR}/plugins/git
# ${ZDOTDIR}/plugins/tmux
# ${ZDOTDIR}/plugins/completion
# ${ZDOTDIR}/plugins/history
# ${ZDOTDIR}/plugins/fzf-catppuccin
# ${ZDOTDIR}/plugins/fzf-helpers
# ${ZDOTDIR}/plugins/fzf-bazel
# ${ZDOTDIR}/plugins/fzf-git
# ${ZDOTDIR}/functions kind:fpath
# ${ZDOTDIR}/plugins/ai
# ${ZDOTDIR}/plugins/titler
EOF

# ===== Final Setup =====
echo "Home configuration complete!"
echo "Please log out and log back in for all changes to take effect."
echo "If you want to use ZSH immediately, run: exec zsh"
