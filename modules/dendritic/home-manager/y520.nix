{self, ...}: {
  flake.modules.homeManager.y520Config = {
    imports = [
      self.modules.homeManager.desktop
    ];

    fonts.fontconfig.enable = true;
    xdg.enable = true;
    xsession.enable = true;

    my = {
      vars = {
        wallpaper = "astronaut.png";
        libva_driver = "iHD";
      };
      stylix = {
        desktop = true;
      };
    };

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
  };
}
