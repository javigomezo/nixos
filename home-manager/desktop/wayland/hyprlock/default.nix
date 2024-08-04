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
          size = "200, 60";
          outline_thickness = 2;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          position = "0, -290";
          halign = "center";
          valign = "center";
          fade_on_empty = false;
          outer_color = "rgb(46, 52, 64)";
          inner_color = "rgb(216, 222, 233)";
          font_color = "rgb(46, 52, 64)";
          hide_input = false;
          placeholder_text = ''<i><span>Hola, $USER</span></i>'';
        }
      ];
      label = [
        {
          text = ''cmd[update:1000] echo -e "$(date +"%H")"'';
          font_size = 180;
          position = "0, 300";
          halign = "center";
          valign = "center";
          color = "rgba(235, 203, 139, 0.82)";
        }
        {
          text = ''cmd[update:1000] echo -e "$(date +"%M")"'';
          font_size = 180;
          position = "0, 75";
          halign = "center";
          valign = "center";
          color = "rgb(216, 222, 233, 0.82)";
        }
        {
          text = ''cmd[update:1000] echo "<span color='##d8dee9'>$(date '+%A, ')</span><span color='##ebcb8b'>$(date '+%d %B')</span>"'';
          font_size = 30;
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
        {
          text = "";
          color = "rgb(216, 222, 233, 0.82)";
          font_size = 50;
          position = "0, -180";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
