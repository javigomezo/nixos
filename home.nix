{ inputs, config, pkgs, ... }:

{
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
      hidpi = false;
    };
    systemdIntegration = true;
    nvidiaPatches = true;
  };


  wayland.windowManager.hyprland.extraConfig = ''
    # Execs
    exec-once= swaylock
    #exec-once = ~/.config/hypr/scripts/xdg-portal-hyprland-nix
    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once = systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=/nix/store/$(ls -la /nix/store | grep polkit-kde-agent | grep '^d' | awk '{print $9}')/libexec/polkit-kde-authentication-agent-1
    exec-once = hyprpaper
    exec-once = waybar
    exec-once = hyprctl setcursor Bibata-Modern-Classic 24
    
    # Env Variables
    env = LIBVA_DRIVER_NAME,nvidia
    env = GBM_BACKEND,nvidia-drm
    env = __GLX_VENDOR_LIBRARY_NAME,nvidia
    env = __GL_GSYNC_ALLOWED,0
    env = __GL_VRR_ALLOWED,0
    env = WLR_DRM_NO_ATOMIC,1
    env = SDL_VIDEODRIVER,x11
    env = WLR_NO_HARDWARE_CURSORS,1
    
    
    env = QT_QPA_PLATFORM,wayland
    env = GDK_BACKEND,wayland,x11
    env = QT_QPA_PLATFORM,wayland;xcb
    #env = SDL_VIDEODRIVER,wayland
    env = CLUTTER_BACKEND,wayland
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_WAYLAND_DISABLE_WINDOWDECORATION,0
    
    # Monitor
    monitor=DP-1,preferred,auto,1
    #monitor=HDMI-A-1,2560x1080@60,1920x0,1
    
    # Wallpapers
    $w1 = hyprctl hyprpaper wallpaper "DP-1,~/Pictures/Wallpaper/dark/mountain.jpg"
    $w2 = hyprctl hyprpaper wallpaper "DP-1,~/Pictures/Wallpaper/dark/river.jpg"
    $w3 = hyprctl hyprpaper wallpaper "DP-1,~/Pictures/Wallpaper/dark/whale.jpg"
    $w4 = hyprctl hyprpaper wallpaper "DP-1,~/Pictures/Wallpaper/dark/astronaut.png"
    
    # Input
    input {
        kb_layout = es
        follow_mouse = 1
        touchpad {
            scroll_factor = 0.5
            natural_scroll = false
            clickfinger_behavior = false
          	tap-to-click = true
            middle_button_emulation = true
        }
    
        sensitivity = 0.3 # -1.0 - 1.0, 0 means no modification.
    }
    
    # Gestures
    gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 4
        workspace_swipe_invert = false
    }
    
    # Mouse
    device:epic mouse V1 {
        sensitivity = -0.5
    }
    
    # Misc
    misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        mouse_move_enables_dpms = true
        enable_swallow = true
        swallow_regex = ^(alacritty)$
        vfr = true
        vrr = 2
    }
    
    # Debug
    debug {
        damage_tracking = 2
    }
    
    # General
    general {
        gaps_in = 3
        gaps_out = 5
        border_size = 2
        no_border_on_floating = true
        col.active_border = rgb(81a1c1)
        col.inactive_border = rgb(3b4252)
        layout = dwindle
    }
    
    # Decoration
    decoration {
        rounding = 8
        multisample_edges = true
        blur = true
        blur_size = 5
        blur_passes = 2
        blur_new_optimizations = true
        blur_ignore_opacity=1
    
        drop_shadow = false
        #shadow_ignore_window = true
        #shadow_offset = 2 2
        #shadow_range = 4
        #shadow_render_power = 2
        #col.shadow = 0x66000000Bold
    }
    
    # Animations
    animations {
        enabled = yes
    
        bezier = wind, 0.05, 0.9, 0.1, 1.05
        bezier = winIn, 0.1, 1.1, 0.1, 1.1
        bezier = winOut, 0.3, -0.3, 0, 1
        bezier = liner, 1, 1, 1, 1
        animation = windows, 1, 6, wind, slide
        animation = windowsIn, 1, 6, winIn, slide
        animation = windowsOut, 1, 5, winOut, slide
        animation = windowsMove, 1, 5, wind, slide
        animation = border, 1, 1, liner
        animation = borderangle, 1, 30, liner, loop
        animation = fade, 1, 10, default
        animation = workspaces, 1, 5, wind
    }
    
    # Dwindle
    dwindle {
        pseudotile = false # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # you probably want this
    }
    
    # Master
    master {
        new_is_master = true
    }
    
    
    # Window Rules
    windowrule = float, file_progress
    windowrule = float, confirm
    windowrule = float, dialog
    windowrule = float, download
    windowrule = float, notification
    windowrule = float, error
    windowrule = float, splash
    windowrule = float, confirmreset
    windowrule = float, title:Open File
    windowrule = float, title:branchdialog
    windowrule = float, Lxappearance
    windowrule = float, viewnior
    windowrule = float, feh
    windowrule = float, file-roller
    windowrule = fullscreen, wlogout
    windowrule = float, title:wlogout
    windowrule = fullscreen, title:wlogout
    windowrule = idleinhibit focus, mpv
    windowrule = idleinhibit fullscreen, com.brave.Browser
    windowrule = idleinhibit fullscreen, firefox
    windowrule = float, title:^(Media viewer)$
    windowrule = float, title:^(Volume Control)$
    windowrule = float, title:^(Picture-in-Picture)$
    windowrule = size 800 600, title:^(Volume Control)$
    windowrule = move 75 44%, title:^(Volume Control)$
    
    windowrulev2 = animation popin, class:^(thunar)$
    windowrulev2 = move 10% 10%, class:^(thunar)$
    windowrulev2 = size 80% 80%, class:^(thunar)$
    windowrulev2 = opacity 0.8 0.8, class:^(thunar)$
    
    # Keybinds
    $mainMod = SUPER
    bind = $mainMod, Return, exec, alacritty
    bind = $mainMod, space, fullscreen
    bind = $mainMod, B, exec, brave
    bind = SHIFT $mainMod, B, exec, TZ=UTC com.brave.Browser --incognito
    bind = $mainMod, C, killactive,
    # bind = $mainMod, D, exec, discord --enable-features=UseOzonePlatform --ozone-platform=wayland --use-gl=egl --enable-features=VaapiVideoDecode --enable-gpu-rasterization --enable-zero-copy --ignore-gpu-blocklist
    bind = SHIFT $mainMod, D, exec, kill -9 $(pidof Discord)
    bind = $mainMod, E, exec, microsoft-edge-stable
    bind = $mainMod, F, exec, firefox
    bind = $mainMod, G, exec, ~/.config/hypr/scripts/game_mode.sh # Toggle Game mode
    bind = SHIFT $mainMod, F, exec, TZ=UTC firefox --private-window
    bind = $mainMod, H, exec, alacritty -e vim ~/.config/hypr/hyprland.conf
    bind = $mainMod, J, togglesplit, # dwindle
    bind = $mainMod, L, exec, swaylock
    bind = $mainMod, M, exec, wlogout
    bind = $mainMod, N, exec, virsh --connect qemu:///system start win10 && virt-viewer --connect qemu:///system -f -w -a win10
    bind = SHIFT $mainMod, M, exit,
    bind = $mainMod, P, exec, tv.plex.PlexDesktop  # For plex
    bind = $mainMod, R, exec, rofi -show drun
    bind = $mainMod, S, exec, grim -g "$(slurp)"
    bind = SHIFT $mainMod, S, exec, grim -g "$(slurp)" - | wl-copy -t image/png  # Screnshot
    bind = $mainMod, T, exec, thunar
    bind = $mainMod, V, togglefloating,
    bind = $mainMod, W, exec, kill -9 $(pidof waybar); waybar
    
    bind=,XF86MonBrightnessUp,exec, light -A 10
    bind=,XF86MonBrightnessDown,exec, light -U 10
    bind=,XF86AudioRaiseVolume,exec, pactl set-sink-volume @DEFAULT_SINK@ +5%
    bind=,XF86AudioLowerVolume,exec, pactl set-sink-volume @DEFAULT_SINK@ -5%
    bind=,XF86AudioMute,exec, pactl set-sink-mute @DEFAULT_SINK@ toggle
    bind=,XF86AudioMicMute,exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle
    
    # Move focus with mainMod + arrow keys
    bind = $mainMod, left, movefocus, l
    bind = $mainMod, right, movefocus, r
    bind = $mainMod, up, movefocus, u
    bind = $mainMod, down, movefocus, d
    
    # Switch workspaces with mainMod + [0-9]
    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 1, exec, $w1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 2, exec, $w2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 3, exec, $w3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 4, exec, $w4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9
    bind = $mainMod, 0, workspace, 10
    
    # Move active window to a workspace with mainMod + SHIFT + [0-9]
    bind = $mainMod SHIFT, 1, movetoworkspace, 1
    bind = $mainMod SHIFT, 1, exec, $w1
    bind = $mainMod SHIFT, 2, movetoworkspace, 2
    bind = $mainMod SHIFT, 2, exec, $w2
    bind = $mainMod SHIFT, 3, movetoworkspace, 3
    bind = $mainMod SHIFT, 3, exec, $w3
    bind = $mainMod SHIFT, 4, movetoworkspace, 4
    bind = $mainMod SHIFT, 4, exec, $w4
    bind = $mainMod SHIFT, 5, movetoworkspace, 5
    bind = $mainMod SHIFT, 6, movetoworkspace, 6
    bind = $mainMod SHIFT, 7, movetoworkspace, 7
    bind = $mainMod SHIFT, 8, movetoworkspace, 8
    bind = $mainMod SHIFT, 9, movetoworkspace, 9
    bind = $mainMod SHIFT, 0, movetoworkspace, 10
    
    # Scroll through existing workspaces with mainMod + scroll
    bind = $mainMod, mouse_down, workspace, e+1
    bind = $mainMod, mouse_up, workspace, e-1
    
    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow
  '';


  home.username = "javier";
  home.homeDirectory = "/home/javier";
  gtk = {
    enable = true;
    theme = {
      name = "Nordic-bluish-accent";
      #package = pkgs.nordic;
    };
  };
  home.packages = [  ];
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
  programs.firefox.package = (pkgs.wrapFirefox.override { libpulseaudio = pkgs.libpressureaudio; }) pkgs.firefox-unwrapped { };
  programs.git = {
    enable = true;
    userName = "javigomezo";
  };

  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
  programs.home-manager.enable = true;
}
