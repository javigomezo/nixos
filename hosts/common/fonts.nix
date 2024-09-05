{
  inputs,
  pkgs,
  ...
}: {
  fonts = {
    packages = [
      inputs.private-fonts.packages.x86_64-linux.ComicCodeLigatures
      pkgs.noto-fonts-emoji
      pkgs.atkinson-hyperlegible
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
