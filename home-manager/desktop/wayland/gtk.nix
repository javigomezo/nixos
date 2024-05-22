{pkgs, ...}: {
  qt.enable = true;
  qt.platformTheme.name = "gtk";
  gtk = {
    enable = true;
    # theme = {
    #   name = "Colloid-Dark-Compact-Nord";
    #   package = pkgs.colloid-gtk-theme.override {
    #     # themeVariants = ["nord"];
    #     colorVariants = ["dark"];
    #     sizeVariants = ["compact"];
    #     tweaks = ["nord"];
    #   };
    #theme = {
    #  name = "Orchis-Dark-Nord";
    #  package = pkgs.orchis-theme.override {
    #    # themeVariants = ["nord"];
    #    tweaks = ["nord"];
    #  };
    #};
    iconTheme = {
      name = "Colloid-nord-dark";
      package = pkgs.colloid-icon-theme.override {
        schemeVariants = ["nord"];
      };
    };
  };
}
