{
  config,
  lib,
  ...
}: let
  mainMonitor =
    builtins.elemAt (map (
      m: "${m.name}"
    ) (lib.filter (m: m.primary) config.monitors))
    0;
in {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
      };
      background = [
        {
          monitor = mainMonitor;
          path = "${config.stylix.image}";
          blur_passes = 2;
          noise = 0.0117;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];
      input-field = [
        {
          monitor = mainMonitor;
          size = "200, 50";
          position = "0, -20";
          outer_color = "rgb(46, 52, 64)";
          inner_color = "rgb(216, 222, 233)";
          font_color = "rgb(46, 52, 64)";
          placeholder_text = "<i>Contraseña...</i>";
        }
      ];
      label = [
        {
          text = "$TIME";
          font_size = 58;
          position = "0, 80";
          halign = "center";
          valign = "center";
          color = "rgb(216, 222, 233)";
        }
      ];
    };
  };
}
