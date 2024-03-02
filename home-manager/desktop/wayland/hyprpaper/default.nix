{
  inputs,
  config,
  pkgs,
  ...
}: {
  home.packages = pkgs.hyprpaper;
  home.file = {
    ".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ~/.config/hypr/space.png
        wallpaper = DP-1,~/.config/hypr/space.png
      '';
    };
    ".config/hypr/space.png" = {
      source = config.lib.file.mkOutOfStoreSymlink ./space.png;
    };
  };
}
