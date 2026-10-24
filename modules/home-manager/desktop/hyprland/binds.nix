{
  flake.modules.homeManager.hyprlandBinds = {
    lib,
    config,
    ...
  }: let
    mod = "SUPER";

    bind = keys: dispatcher: flags: let
      flagsArg = lib.optionalString (flags != "") ", ${flags}";
    in ''hl.bind("${keys}", ${dispatcher}${flagsArg})'';

    exec = cmd: ''hl.dsp.exec_cmd("${cmd}")'';

    workspaces = builtins.genList (i: toString (i + 1)) 9;
    directions = {
      h = "l";
      l = "r";
      k = "u";
      j = "d";
    };

    lines =
      [
        (bind "${mod} + Return" (exec "uwsm app -- kitty") "")
        (bind "${mod} + space" ''hl.dsp.window.fullscreen({ action = "toggle" })'' "")
        (bind "${mod} + C" "hl.dsp.window.close()" "")
        (bind "${mod} + D" (exec "uwsm app -- discord") "")
        (bind "${mod} + F" (exec "uwsm app -- firefox") "")
        (bind "${mod} + SHIFT + F" (exec "TZ=UTC uwsm app -- firefox --private-window") "")
        (bind "${mod} + G" (exec "uwsm app -- ${config.home.homeDirectory}/.config/hypr/scripts/game_mode.sh") "")
        (bind "${mod} + J" ''hl.dsp.layout("togglesplit")'' "")
        (bind "${mod} + L" (exec "uwsm app -- hyprlock") "")
        (bind "${mod} + M" (exec "uwsm app -- noctalia msg panel-toggle session") "")
        (bind "${mod} + SHIFT + M" "hl.dsp.exit()" "")
        (bind "${mod} + O" (exec "uwsm app -- obsidian --ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandLinuxDrmSyncobj") "")
        (bind "${mod} + P" (exec "uwsm app -- plezy") "")
        (bind "${mod} + R" (exec "uwsm app -- noctalia msg panel-toggle launcher") "")
        (bind "${mod} + S" (exec "uwsm app -- grimblast --cursor --freeze --notify copysave screen") "")
        (bind "${mod} + SHIFT + S" (exec "uwsm app -- grimblast --freeze --notify copy area") "")
        (bind "${mod} + T" (exec "uwsm app -- thunar") "")
        (bind "${mod} + V" (exec "uwsm app -- noctalia msg panel-toggle clipboard") "")
        (bind "${mod} + SHIFT + V" ''hl.dsp.window.float({ action = "toggle" })'' "")
        (bind "${mod} + W" (exec "systemctl --user restart noctalia.service") "")

        (bind "${mod} + mouse_up" ''hl.dsp.focus({ workspace = "e+1" })'' "")
        (bind "${mod} + mouse_down" ''hl.dsp.focus({ workspace = "e-1" })'' "")
        (bind "${mod} + right" ''hl.dsp.focus({ workspace = "e+1" })'' "")
        (bind "${mod} + left" ''hl.dsp.focus({ workspace = "e-1" })'' "")

        (bind "XF86MonBrightnessUp" (exec "brightnessctl set 5%+") "")
        (bind "XF86MonBrightnessDown" (exec "brightnessctl set 5%-") "")
        (bind "XF86AudioRaiseVolume" (exec "noctalia msg volume-up") "")
        (bind "XF86AudioLowerVolume" (exec "noctalia msg volume-down") "")
        (bind "XF86AudioMute" (exec "wpctl set-mute @DEFAULT_SINK@ toggle") "")
        (bind "XF86AudioMicMute" (exec "wpctl set-mute @DEFAULT_SOURCE@ toggle") "")

        # Move/resize windows with mainMod + LMB/RMB dragging (formerly `bindm`)
        (bind "${mod} + mouse:272" "hl.dsp.window.drag()" "{ mouse = true }")
        (bind "${mod} + mouse:273" "hl.dsp.window.resize()" "{ mouse = true }")
      ]
      ++ map (n: bind "${mod} + ${n}" "hl.dsp.focus({ workspace = ${n} })" "") workspaces
      ++ map (n: bind "${mod} + SHIFT + ${n}" "hl.dsp.window.move({ workspace = ${n} })" "") workspaces
      ++ lib.mapAttrsToList (key: direction: bind "ALT + ${key}" ''hl.dsp.focus({ direction = "${direction}" })'' "") directions;
  in {
    wayland.windowManager.hyprland.extraConfig = lib.concatStringsSep "\n" lines + "\n";
  };
}
