{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "match:class ^(file_progress), float on"
      "match:class ^(confirm), float on"
      "match:class ^(dialog), float on"
      "match:class ^(download), float on"
      "match:class ^(notification), float on"
      "match:class ^(error), float on"
      "match:class ^(splash), float on"
      "match:class ^(confirmreset), float on"
      "match:title Open File, float on"
      "match:title branchdialog, float on"
      "match:title file-roller, float on"
      "match:title wlogout, float on"
      "match:title ^(Media viewer)$, float on"
      "match:title ^(Control de volumen)$, float on"
      "match:title ^(Picture-in-Picture)$, float on"
      "match:title ^(Authentication Required)$, float on"
      "match:class ^(wlogout), fullscreen on"
      "match:title wlogout, fullscreen on"
      "match:class ^(mpv), idle_inhibit focus"
      "match:class ^(Firefox), idle_inhibit fullscreen"
      "match:class ^(obsidian)$, idle_inhibit focus"
      "match:title ^(Control de volumen)$, size 800 600"
      "match:class ^(obsidian)$, workspace 5"
      "match:class ^(thunar)$, animation popin"
      "match:class ^(thunar)$, opacity 0.82 0.82"
      "match:class ^(obsidian)$, opacity 0.92 0.92"
      "match:float 1, border_size 0"
    ];
    layerrule = [
      "match:namespace noctalia-background-.*$, ignore_alpha 0.5"
      "match:namespace noctalia-background-.*$, blur on"
      "match:namespace noctalia-background-.*$, blur_popups on"
    ];
  };
}
