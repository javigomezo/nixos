{ config, pkgs, ... }:

{
  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  xwayland = {
  #    enable = true;
  #    hidpi = false;
  #  };
  #  systemdIntegration = true;
  #  nvidiaPatches = true;
  #};

  home.username = "javier";
  home.homeDirectory = "/home/javier";
  gtk = {
    enable = true;
    theme = {
      name = "Nordic-bluish-accent";
      #package = pkgs.nordic;
    };
  };
  home.packages = [  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  programs.firefox.package = (pkgs.wrapFirefox.override { libpulseaudio = pkgs.libpressureaudio; }) pkgs.firefox-unwrapped { };
  programs.git = {
    enable = true;
    userName = "javigomezo";
  };

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
