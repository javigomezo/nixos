{
  lib,
  config,
  ...
}: {
  imports = [
    ./execs.nix
    ./binds.nix
    ./animations.nix
    ./decorations.nix
    ./windowrule.nix
    ./game_mode.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
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
      render.explicit_sync = true;
      input = {
        kb_layout = "es";
        kb_options = "caps:super";
        follow_mouse = 1;
        sensitivity = 0.3;
        touchpad = {
          scroll_factor = 0.5;
          natural_scroll = false;
          clickfinger_behavior = false;
          tap-to-click = true;
          middle_button_emulation = true;
        };
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 4;
        workspace_swipe_invert = false;
      };
      misc = {
        allow_session_lock_restore = true;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        mouse_move_enables_dpms = true;
        enable_swallow = true;
        swallow_regex = "^(kitty)$";
        vfr = true;
        vrr = 1;
      };
      debug.damage_tracking = 2;
      dwindle = {
        pseudotile = false;
        preserve_split = true;
      };
      #master.new_is_master = true;
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
    HYPRCURSOR_THEME = "bibata-modern-classic-hyprcursor";
    HYPRCURSOR_SIZE = 24;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WLR_NO_HARDWARE_CURSORS = 1;
  };
}
