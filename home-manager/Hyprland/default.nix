{ lib, config, pkgs, ... }:

{
  
  #imports = [ inputs.hyprland.homeManagerModules.default ];
  wayland.windowManager.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.system}.default;
    extraConfig = builtins.readFile ./hyprland.conf;
    xwayland = {
      enable = true;
      hidpi = false;
    };
    systemdIntegration = true;
    enableNvidiaPatches = true;
  };
}
