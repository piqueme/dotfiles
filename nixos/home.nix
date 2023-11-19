{ config, dotdir, pkgs, ... }:
let
  dotdir = "${builtins.toString ./..}";
  zdotdir = "${dotdir}/zsh";
in {
  home.username = "obe";
  home.homeDirectory = "/home/obe";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # Supah fast terminal emulator
    pkgs.alacritty
    # Terminal multiplexer and session management
    pkgs.tmux
    # Daily driver text editor
    pkgs.neovim

    # Common network URL fetching tool.
    pkgs.curl
    # Ergonomic JSON manipulation in the terminal.
    pkgs.jq
    # More usable quick text view (e.g. includes syntax highlighting vs. cat).
    pkgs.bat

    # Meta-tool: fuzzy finder. Very useful UI for acting on list items.
    pkgs.fzf
    # Helpful file jumping.
    pkgs.zoxide
    # Better "ls" for directory traversal.
    pkgs.eza
    # Faster file-finder (vs. `find`).
    pkgs.fd
    # Fast and usable text search tool
    pkgs.ripgrep
    # Terminal file explorer
    pkgs.nnn

    # GPT in your terminal: helpful for doc searching, code generation
    pkgs.shell_gpt

    # System monitoring tool.
    pkgs.glances
    # Container monitoring tool.
    pkgs.ctop
    # Container management tool.
    pkgs.docker
    # Local Kubernetes testing tool
    pkgs.kind
    pkgs.kubectl
    pkgs.kubernetes-helm

    # Javascript development.
    pkgs.yarn
    pkgs.nodejs_18

    # C compilation support.
    # Should be moved to per-project eventually.
    pkgs.gcc

    # Go development support.
    # Should be moved to per-project eventually.
    pkgs.go
    pkgs.buf
    pkgs.protoc-gen-go
    pkgs.protoc-gen-connect-go

    # Bazel.
    # Also probably better per-project.
    pkgs.bazel

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
  ];

  home.file = {
    ".p10k.zsh".source = ../zsh/p10k.zsh;

    # Ideally we could let home-manager control this.
    # For whatever reason, NixOS places its own.
    # ".config/i3" = {
    #   source = ../i3;
    #   recursive = true;
    # };

    ".config/rofi" = {
      source = ../rofi;
      recursive = true;
    };

    ".config/polybar" = {
      source = ../polybar;
      recursive = true;
    };

    # TODO: Figure out a good way of setting the shell_gpt rc
    # despite requiring a secret from OpenAI.
    # ".config/shell_gpt" = {
    #   source = ../shell_gpt;
    #   recursive = true;
    # };

    ".config/alacritty" = {
      source = ../alacritty;
      recursive = true;
    };

    # TODO: Not sure if I can have home-manager be responsible
    # for X environment settings.
    # ".Xmodmap".source = ../x/Xmodmap
  };

  # NOTE: The shell (zsh) is managed through home-manager
  # and so automatically sources environment variables here correctly.
  home.sessionVariables = {};

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    antidote = {
      enable = true;
      # TODO: Better synchronization with antidote config file in dotfiles repo.
      plugins = [
        # ZSH Prompt Plugin
        "romkatv/powerlevel10k"
        # ZSH Profiling tool
        "romkatv/zsh-bench kind:path"
        # Standard shell helpers.
        "zdharma-continuum/fast-syntax-highlighting kind:defer"
        "zsh-users/zsh-autosuggestions kind:defer"
        "zsh-users/zsh-completions kind:fpath path:src"
        # Personal plugins.
        "${zdotdir}/plugins/core"
        "${zdotdir}/plugins/git"
        "${zdotdir}/plugins/tmux"
        "${zdotdir}/plugins/completion"
        "${zdotdir}/plugins/history"
        "${zdotdir}/plugins/fzf-catppuccin"
        "${zdotdir}/plugins/fzf-helpers"
        "${zdotdir}/plugins/fzf-bazel"
        "${zdotdir}/plugins/fzf-git"
        "${zdotdir}/functions kind:fpath"
      ];
    };
    # NOTE: This needs to go in initExtraFirst to ensure the prompt loads quickly.
    # It cannot be added to the end of zshrc.
    # TODO: Reduce need for external environment variables.
    initExtraFirst = ''
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
    '';
    initExtra = ''
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
      eval "$(zoxide init zsh)"
    '';
  };
}
