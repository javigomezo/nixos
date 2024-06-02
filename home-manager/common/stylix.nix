{
  inputs,
  pkgs,
  vars,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
  ];
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/nord.yaml";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    fonts = {
      monospace = {
        name = "Comic Code Ligatures";
        package = inputs.private-fonts.packages.x86_64-linux.ComicCodeLigatures;
      };
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-emoji;
      };
      sizes = {
        terminal = 12;
        desktop = 10;
        popups = 10;
      };
    };
    opacity = {
      terminal = 0.82;
    };
    targets.vim.enable = false;
    targets.waybar.enable = false;
    targets.rofi.enable = true;
    image = ../desktop/wayland/hyprpaper/wallpapers/${vars.wallpaper};
    polarity = "dark";
  };
}
