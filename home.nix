{ config, pkgs, ... }:

{
  home.username = "javier";
  home.homeDirectory = "/home/javier";
  gtk = {
    enable = true;
    theme = {
      name = "Nordic-bluish-accent";
      #package = pkgs.nordic;
    };
  };
  home.stateVersion = "23.05";
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
}
