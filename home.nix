{ config, dotdir, pkgs, ... }:
let
  dotdir = "${builtins.toString ./.}";
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
    # Common network URL fetching tool.
    pkgs.curl
    # Ergonomic JSON manipulation in the terminal.
    pkgs.jq
    # More usable quick text view (e.g. includes syntax highlighting vs. cat).
    pkgs.bat
    # System monitoring tool.
    pkgs.glances

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

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/obe/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
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
        "${zdotdir}/plugins/p10k-config"
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
      eval "$(zoxide init zsh)"
    '';
  };
}
