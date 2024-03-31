{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./common
    ./optional/impermanence.nix
    ./desktop/wayland
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = true;
  xsession.enable = true;

  monitors = [
    {
      enabled = true;
      primary = true;
      name = "eDP-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 0;
    }
    {
      enabled = true;
      primary = false;
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1920;
    }
  ];
  home.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
