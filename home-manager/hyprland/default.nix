{ lib, config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    xwayland = {
      enable = true;
      #hidpi = true;
    };
    systemdIntegration = true;
    enableNvidiaPatches = true;
  };
}
