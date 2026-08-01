{
  flake.modules.homeManager.hyprlandDecorations = {
    wayland.windowManager.hyprland.settings.config = {
      decoration = {
        rounding = 8;
        blur = {
          enabled = true;
          size = 5;
          passes = 2;
          ignore_opacity = true;
        };
        shadow = {
          enabled = true;
        };
      };
    };
  };
}
