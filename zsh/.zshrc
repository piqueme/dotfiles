# This is a manual .zshrc that matches the Nix-generated config.
# This file is maintained largely for portability (non-Nix users can copy).
# It should be extremely thin, deferring largely to package-managers and critical initialization tools.

# Pull the Antidote plugin manager if it doesn't already exist.
ANTIDOTE_DIR="${ZDOTDIR:-~}/.antidote"
if [ ! -d "$ANTIDOTE_DIR" ]; then
  echo "Antidote not found at $ANTIDOTE_DIR. Downloading..."
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
fi

# p10k Instant Prompt.
# This effectively renders the prompt while plugins are being loaded.
# Unfortunately, if plugins haven't been fetched it will actually hang until plugins are fetched...but this should be rare.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# source antidote
source "$ANTIDOTE_DIR/antidote.zsh"

# initialize plugins statically with ${ZDOTDIR:-~}/.zsh_plugins.txt
antidote load
