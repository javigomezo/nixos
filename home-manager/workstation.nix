{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common
    ./desktop/wayland
  ];

  fonts.fontconfig.enable = true;
  xdg.enable = true;
  xsession.enable = true;

  monitors = [
    {
      enabled = true;
      primary = true;
      name = "DP-1";
      width = 2560;
      height = 1080;
      x = 0;
    }
  ];
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
