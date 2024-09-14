{
  lib,
  pkgs,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    settings = {
      exec-once = [
        "${lib.getExe config.programs.hyprlock.package}"
        "${pkgs.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
        "hyprctl setcursor bibata-modern-classic-hyprcursor 24"
      ];
    };
  };
}
