{self, ...}: {
  flake.modules.homeManager.hyprland = {
    lib,
    config,
    ...
  }: {
    imports = with self.modules.homeManager; [
      hyprlandExecs
      hyprlandBinds
      hyprlandAnimations
      hyprlandDecorations
      hyprlandWindowRule
      hyprlandGameMode
    ];

    services.hyprpaper.enable = lib.mkForce false;
    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";
      xwayland.enable = true;
      systemd = {
        enable = false;
        # extraCommands = lib.mkBefore [
        #   "systemctl --user stop graphical-session.target"
        #   "systemctl --user start hyprland-session.target"
        # ];
        # variables = ["--all"];
      };
      settings = {
        # cursor = {
        #   no_hardware_cursors = false;
        #   #allow_dumb_copy = true;
        # };
        config.input = {
          kb_layout = "es";
          kb_options = "caps:super";
          follow_mouse = 1;
          sensitivity = 0.3;
          touchpad = {
            scroll_factor = 0.5;
            natural_scroll = false;
            clickfinger_behavior = false;
            tap_to_click = true;
            middle_button_emulation = true;
          };
        };

        workspace_rule =
          builtins.genList (
            i: let
              ws = i + 1;
              baseConfig = {
                workspace = toString ws;
                persistent = true;
              };
              scrollingLayout = {
                workspace = toString ws;
                persistent = true;
                layout = "scrolling";
              };
            in
              if ws == 4
              then scrollingLayout
              else baseConfig
          )
          5;

        gesture = {
          fingers = 4;
          direction = "horizontal";
          action = "workspace";
        };

        config = {
          gestures = {
            workspace_swipe_invert = false;
          };

          misc = {
            allow_session_lock_restore = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            mouse_move_enables_dpms = true;
            enable_swallow = true;
            swallow_regex = "^(kitty)$";
            # vfr = true;
            vrr = 1;
          };
          scrolling = {
            fullscreen_on_one_column = true;
            column_width = 0.9;
            direction = "right";
          };
          dwindle = {
            preserve_split = true;
          };
        };
        #master.new_is_master = true;
        monitor = map (
          m: let
            monitor_resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
            monitor_position = "${toString m.x}x${toString m.y}";
          in
            if m.enabled
            then
              if m.auto
              then {
                output = m.name;
                mode = "preferred";
                position = "auto-right";
                scale = 1;
              }
              else {
                output = m.name;
                mode = monitor_resolution;
                position = monitor_position;
                scale = 1;
              }
            else {
              output = m.name;
              mode = "disable";
            }
        ) (lib.filter (m: m.enabled != null) config.my.monitors);
      };
    };
  };
}
