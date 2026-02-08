{
  lib,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    settings = {
      exec-once = [
        "${lib.getExe config.programs.hyprlock.package}"
        "systemctl --user start hyprpolkitagent.service"
        "hyprctl setcursor bibata-modern-classic-hyprcursor 24"
        "noctalia-shell"
      ];
    };
  };
}
