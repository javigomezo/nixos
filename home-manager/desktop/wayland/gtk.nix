{pkgs, ...}: {
  qt.enable = true;
  qt.platformTheme.name = "gtk";
  gtk = {
    enable = true;
    iconTheme = {
      name = "Colloid-nord-dark";
      package = pkgs.colloid-icon-theme.override {
        schemeVariants = ["nord"];
      };
    };
  };
}
