{
  lib,
  pkgs,
  ...
}: {
  qt.enable = true;
  qt.platformTheme = "gtk";
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
    theme = {
      name = "Orchis-Dark-Nord";
      package = pkgs.orchis-theme.override {
        # themeVariants = ["nord"];
        tweaks = ["nord"];
      };
    };
    iconTheme = {
      name = "Colloid-nord-dark";
      package = pkgs.colloid-icon-theme.override {
        schemeVariants = ["nord"];
      };
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    # cursorTheme = {
    #   name = "Nordzy-cursors";
    #   package = pkgs.nordzy-cursor-theme;
    #   size = 30;
    # };
  };
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
}
