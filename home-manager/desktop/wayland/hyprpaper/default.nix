{
  lib,
  config,
  pkgs,
  vars,
  ...
}: let
  mainMonitor =
    builtins.elemAt (map (
      m: "${m.name}"
    ) (lib.filter (m: m.primary) config.monitors))
    0;
in {
  home.packages = [pkgs.hyprpaper];
  home.file = {
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ${config.home.homeDirectory}/.config/hypr/wallpapers/${vars.wallpaper}
        wallpaper = ${mainMonitor},${config.home.homeDirectory}/.config/hypr/wallpapers/${vars.wallpaper}
      '';
    };
    ".config/hypr/wallpapers" = {
      source = config.lib.file.mkOutOfStoreSymlink ./wallpapers;
      recursive = true;
    };
  };
}
