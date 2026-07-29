{self, ...}: {
  flake.modules.homeManager.nuc8i3behConfiguration = {
    imports = [self.modules.homeManager.cli];

    my.stylix.desktop = false;
    xdg.enable = true;

    # You can update home Manager without changing this value. See
    # the home Manager release notes for a list of state version
    # changes in each release.
    home.stateVersion = "25.05";
  };
}
