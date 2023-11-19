# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Ensure we can mount NTFS drives - older stuff fits the bill.
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # # Language Support
  # # Ideally should get this working, but
  # # for whatever reason the addons do not get installed.
  # i18n.inputMethod = {
  #   enabled = "fcitx5";
  #   fcitx5.addons = with pkgs; [
  #     fcitx5-mozc
  #     fcitx5-chinese-addons
  #     fcitx5-gtk
  #   ];
  # };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
 
    # No need for a desktop manager, we will use i3 lock.
    desktopManager = {
      xterm.enable = false;
    };

    # Keyboard layout
    layout = "us";
    xkbVariant = "";
    
    # Use i3 window manager for display management.
    displayManager = {
      defaultSession = "none+i3";
      
      sessionCommands = ''
      # Load user default Xmodmap for keyboard layout adjustments, e.g. caps -> ctrl
      [ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap

      # Setup background image on login
      ${pkgs.feh}/bin/feh --bg-scale ~/.wallpaper/background_image.jpeg
      '';
    };

    windowManager.i3 = {
     enable = true;
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Defines a user account. Password is established separately via `passwd`.
  users.users.obe = {
    isNormalUser = true;
    description = "Sumit Gogia";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Package overrides
  nixpkgs.config.packageOverrides = pkgs: rec {
    polybar = pkgs.polybar.override {
      i3Support = true;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Baseline Image Viewer
    feh
    # Basic editor
    vim
    # Web browser
    firefox
    # Terminal
    alacritty
    # Version control system
    git
    # Status bar
    polybar
    # Application launcher w/ nice UI
    rofi
    # Minimal screen lock for i3
    i3lock
    # keyboard management
    xorg.xmodmap
    xorg.xev
  ];

  # Make ZSH available as a system package.
  programs.zsh = {
    enable = true;
    enableCompletion = false;
  };

  programs._1password.enable = true; 
  programs._1password-gui = {
    enable = true; 
    # Just in case we're using a desktop environment which
    # needs this for CLI support / system authentication.
    # See https://nixos.wiki/wiki/1Password 
    polkitPolicyOwners = [ "obe" ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  # Set up docker.
  virtualisation.docker.enable = true;
}