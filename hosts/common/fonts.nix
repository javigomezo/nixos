{ inputs, pkgs, ...}:
{
  fonts = {
    packages = [
      inputs.private-fonts
      pkgs.noto-fonts-emoji
      # font-awesome
      (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    ];
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
    };
  };
}
