{pkgs, ...}: {
  qt.enable = true;
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
