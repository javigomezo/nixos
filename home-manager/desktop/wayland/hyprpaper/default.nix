{
  inputs,
  config,
  pkgs,
  vars,
  ...
}: {
  home.packages = [pkgs.hyprpaper];
  home.file = {
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ${config.home.homeDirectory}/.config/hypr/wallpapers/${vars.wallpaper}
        wallpaper = DP-1,${config.home.homeDirectory}/.config/hypr/wallpapers/${vars.wallpaper}
      '';
    };
    ".config/hypr/wallpapers" = {
      source = config.lib.file.mkOutOfStoreSymlink ./wallpapers;
      recursive = true;
    };
  };
}
