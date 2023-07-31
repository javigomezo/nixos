{ inputs, config, pkgs, ... }:

{
  imports = [
    ./Hyprland
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

  #wayland.windowManager.hyprland = {
  #  enable = true;
  #  package = inputs.hyprland.packages.${pkgs.system}.default;
  #  extraConfig = builtins.readFile ./Hyprland/hyprland.conf;
  #  xwayland = {
  #    enable = true;
  #    hidpi = false;
  #  };
  #  systemdIntegration = true;
  #  nvidiaPatches = true;
  #};

  home.username = "javier";
  home.homeDirectory = "/home/javier";
  qt.enable = true;
  gtk = {
    enable = true;
    theme = {
      name = "Nordic-bluish-accent";
      #package = pkgs.nordic;
    };
  };
  home.packages = with pkgs; [
    polkit-kde-agent
    xwayland
  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  programs.firefox.package = (pkgs.wrapFirefox.override { libpulseaudio = pkgs.libpressureaudio; }) pkgs.firefox-unwrapped { };
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "javigomezo";
  };


  xsession.enable = true;

  systemd.user.startServices = "sd-switch";

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
