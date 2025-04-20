{
  imports = [
    ./common
    ./desktop/wayland
  ];

  my.stylix.desktop = true;

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
      auto = true;
      name = "HDMI-A-1";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 1920;
    }
  ];
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
