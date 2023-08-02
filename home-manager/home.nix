{ lib, config, pkgs, ... }:

{
  imports = [
    ./Hyprland
    ./waybar
    ./zsh
  ];

  nixpkgs = {
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "javier";
    homeDirectory = "/home/javier";
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    packages = with pkgs; [
      alacritty
      bibata-cursors
      duf
      exa
      firefox-wayland
      ffmpeg
      gamescope
      git
      grim
      hyprpaper
      killall
      nitch
      htop
      mako
      mpv
      pavucontrol
      polkit-kde-agent
      protonup-qt
      (python3.withPackages(ps: with ps; [ requests ]))
      rofi-wayland-unwrapped
      slurp
      stow
      swaylock-effects
      tmux
      vim
      wl-clipboard
      wlogout
      xfce.thunar
      #xorg.xorgserver
      xwayland
    ];
  };

  qt.enable = true;
  gtk = {
    enable = true;
    theme = {
      name = "Nordic-bluish-accent";
    };
  };

  #programs.thunar.plugins = with pkgs.xfce; [
  #  thunar-archive-plugin
  #  thunar-volman
  #];
  programs.firefox.package = (pkgs.wrapFirefox.override { libpulseaudio = pkgs.libpressureaudio; }) pkgs.firefox-unwrapped { };
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "javigomezo";
  };

  xdg.enable = true;
  fonts.fontconfig.enable = true;
  #xdg.portal = {
  #  enable = true;
  #  extraPortals = [
  #    pkgs.xdg-desktop-portal-hyprland
  #    pkgs.xdg-desktop-portal-gtk
  #  ];
  #};

  xsession.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
