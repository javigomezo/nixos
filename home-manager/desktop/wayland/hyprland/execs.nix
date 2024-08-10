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
        "${lib.getExe pkgs.lxqt.lxqt-policykit}"
        #"hyprlock"
        #"lxqt-policykit-agent"
      ];
    };
  };
}
