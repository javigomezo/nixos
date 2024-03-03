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

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
