{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./desktop/wayland
    ./starship
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
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "javier";
    homeDirectory = "/home/javier";
  };

  programs = {
    home-manager.enable = true;
    neovim = {
      enable = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      userName = "javigomezo";
      userEmail = "mail@javigomezo.com";
    };
  };

  xdg.enable = true;
  fonts.fontconfig.enable = true;

  xsession.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
