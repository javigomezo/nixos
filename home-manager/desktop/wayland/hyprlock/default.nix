{
  inputs,
  config,
  lib,
  vars,
  ...
}: let
  mainMonitor =
    builtins.elemAt (map (
      m: "${m.name}"
    ) (lib.filter (m: m.primary) config.monitors))
    0;
in {
  imports = [
    inputs.hyprlock.homeManagerModules.hyprlock
  ];
  programs.hyprlock = {
    enable = true;
    general = {
      grace = 0;
    };
    backgrounds = [
      {
        monitor = mainMonitor;
        path = "${config.home.homeDirectory}/.config/hypr/wallpapers/${vars.wallpaper}";
        blur_passes = 2;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      }
    ];
    input-fields = [
      {
        monitor = mainMonitor;
        outer_color = "rgb(46, 52, 64)";
        inner_color = "rgb(216, 222, 233)";
        font_color = "rgb(46, 52, 64)";
        placeholder_text = "<i>Contraseña...</i>";
      }
    ];
    labels = [
      {
        text = "$TIME";
        font_size = 58;
        color = "rgb(216, 222, 233)";
      }
    ];
  };
}
