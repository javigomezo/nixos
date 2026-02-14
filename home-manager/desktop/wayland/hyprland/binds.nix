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
      workspaces = builtins.genList (i: "${toString (i + 1)}") 9;

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
        "SUPER,D,exec,uwsm app -- discord"
        "SUPER,F,exec,uwsm app -- firefox"
        "SUPERSHIFT,F,exec,TZ=UTC uwsm app -- firefox --private-window"
        "SUPER,G,exec,uwsm app -- ${config.home.homeDirectory}/.config/hypr/scripts/game_mode.sh"
        "SUPER,J,togglesplit"
        "SUPER,L,exec,uwsm app -- hyprlock"
        "SUPER,M,exec,uwsm app -- noctalia-shell ipc call sessionMenu toggle"
        "SUPERSHIFT,M,exit"
        "SUPER,O,exec,uwsm app -- obsidian --ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandLinuxDrmSyncobj"
        #"SUPER,P,exec,uwsm app -- tv.plex.PlexDesktop"
        "SUPER,P,exec,QT_QPA_PLATFORM=xcb uwsm app -- plex-desktop"
        #"SUPER,R,exec,rofi -show drun"
        # "SUPER,R,exec,uwsm app -- ${wofi} -S drun"
        "SUPER,R,exec,uwsm app -- noctalia-shell ipc call launcher toggle"
        "SUPER,S,exec,uwsm app -- grimblast --cursor --freeze --notify copysave screen"
        "SUPERSHIFT,S,exec,uwsm app -- grimblast --freeze --notify copy area"
        "SUPER,T,exec,uwsm app -- thunar"
        "SUPER,V,exec,uwsm app -- noctalia-shell ipc call launcher clipboard"
        # ''SUPER,V,exec,selected=$(${cliphist} list | ${wofi} -S dmenu) && echo "$selected" | ${cliphist} decode | wl-copy''
        "SUPERSHIFT,V,togglefloating"
        "SUPER,W,exec,systemctl --user restart waybar.service"
        "SUPER,mouse_up,workspace,e-1"
        "SUPER,mouse_down,workspace,e+1"
        "SUPER, right,workspace,e+1"
        "SUPER, left,workspace,e-1"
        ",XF86MonBrightnessUp,exec,brightnessctl set 5%+"
        ",XF86MonBrightnessDown,exec,brightnessctl set 5%-"
        ",XF86AudioRaiseVolume,exec,wpctl set-volume @DEFAULT_SINK@ 1%+"
        ",XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_SINK@ 1%-"
        #",KEY_VOLUMEUP,exec,wpctl set-volume @DEFAULT_SINK@ 1%+"
        #",KEY_VOLUMEDOWN,exec,wpctl set-volume @DEFAULT_SINK@ 5%-"
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
