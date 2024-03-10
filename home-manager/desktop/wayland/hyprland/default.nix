{
  lib,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./execs.nix
    ./binds.nix
    ./animations.nix
    ./decorations.nix
    ./game_mode.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
    xwayland = {
      enable = true;
      #hidpi = true;
    };
    systemd = {
      enable = true;
      extraCommands = lib.mkBefore [
        "systemctl --user stop graphical-session.target"
        "systemctl --user start hyprland-session.target"
      ];
      variables = ["--all"];
    };
    settings = {
      monitor = map (
        m: let
          resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
          position = "${toString m.x}x${toString m.y}";
        in "${m.name},${
          if m.enabled
          then "${resolution},${position},1"
          else "disable"
        }"
      ) (lib.filter (m: m.enabled != null) config.monitors);
    };
  };
  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WLR_NO_HARDWARE_CURSORS = 1;
  };
}
