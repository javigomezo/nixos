{
  config,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "SUPER,mouse:272,movewindow"
      "SUPER,mouse:273,resizewindow"
    ];
    bind = let
      cliphist = lib.getExe config.services.cliphist.package;
      wofi = lib.getExe config.programs.wofi.package;
      workspaces = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
      directions = {
        left = "l";
        right = "r";
        up = "u";
        down = "d";
      };
    in
      [
        "SUPER,Return,exec,uwsm app -- kitty"
        "SUPER,space,fullscreen"
        "SUPER,C,killactive"
        "SUPER,F,exec,uwsm app -- firefox"
        "SUPERSHIFT,F,exec,TZ=UTC uwsm app -- firefox --private-window"
        "SUPER,G,exec,uwsm app -- ${config.home.homeDirectory}/.config/hypr/scripts/game_mode.sh"
        "SUPER,J,togglesplit"
        "SUPER,L,exec,uwsm app -- hyprlock"
        "SUPER,M,exec,uwsm app -- wlogout"
        "SUPERSHIFT,M,exit"
        "SUPER,O,exec,uwsm app -- obsidian --ozone-platform=wayland --enable-features=UseOzonePlatform"
        #"SUPER,P,exec,uwsm app -- tv.plex.PlexDesktop"
        "SUPER,P,exec,uwsm app -- plex-desktop"
        #"SUPER,R,exec,rofi -show drun"
        "SUPER,R,exec,uwsm app -- ${wofi} -S drun"
        "SUPER,S,exec,uwsm app -- grimblast --cursor --freeze --notify copysave screen"
        "SUPERSHIFT,S,exec,uwsm app -- grimblast --freeze --notify copy area"
        "SUPER,T,exec,uwsm app -- thunar"
        ''SUPER,V,exec,selected=$(${cliphist} list | ${wofi} -S dmenu) && echo "$selected" | ${cliphist} decode | wl-copy''
        "SUPERSHIFT,V,togglefloating"
        "SUPER,W,exec,systemctl --user restart waybar.service"
        "SUPER,mouse_down,workspace,e+1"
        "SUPER,mouse_up,workspace,e-1"
        ",XF86MonBrightnessUp,exec,brightnessctl set 5%+"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_SINK@ 5%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_SINK@ 5%-"
        ",XF86AudioMute,exec,wpctl set-mute @DEFAULT_SINK@ toggle"
        ",XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_SOURCE@ toggle"
      ]
      ++
      # Change workspace
      (map (
          n: "SUPER,${n},workspace,${n}"
        )
        workspaces)
      # Move window to workspace
      ++ (map (
          n: "SUPERSHIFT,${n},movetoworkspace,${n}"
        )
        workspaces)
      ++
      # Move focus
      (lib.mapAttrsToList (
          key: direction: "SUPER,${key},movefocus,${direction}"
        )
        directions);
  };
}
