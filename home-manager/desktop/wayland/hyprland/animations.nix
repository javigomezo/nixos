{lib, ...}: {
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 3;
      gaps_out = 5;
      border_size = 2;
      # no_border_on_floating = true;
      "col.active_border" = lib.mkForce "rgb(81a1c1)";
      layout = "dwindle";
    };
    settings.animations = {
      # enabled = true;
      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
      ];
      animation = [
        "windows, 1, 6, wind, slide"
        "windowsIn, 1, 6, winIn, slide"
        "windowsOut, 1, 5, winOut, slide"
        "windowsMove, 1, 5, wind, slide"
        "border, 1, 1, liner"
        "borderangle, 1, 30, liner, loop"
        "fade, 1, 10, default"
        "workspaces, 1, 5, wind"
      ];
    };
  };
}
