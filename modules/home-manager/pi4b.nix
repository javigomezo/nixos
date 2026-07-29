{self, ...}: {
  flake.modules.homeManager.pi4bConfig = {
    imports = [self.modules.homeManager.cli];

    my.stylix.desktop = false;
    my.vars.wallpaper = "space.png";
    xdg.enable = true;

    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "24.05";
  };
}
