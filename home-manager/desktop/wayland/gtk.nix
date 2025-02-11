{pkgs, ...}: {
  qt.enable = true;
  gtk = {
    enable = true;
    iconTheme = {
      # name = "Colloid-Nord-Dark";
      # package = pkgs.colloid-icon-theme.override {
      #   schemeVariants = ["nord"];
      # };
      name = "kora";
      package = pkgs.stable.kora-icon-theme;
    };
  };
}
