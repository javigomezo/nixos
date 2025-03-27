{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float, class:^(file_progress)"
      "float, class:^(confirm)"
      "float, class:^(dialog)"
      "float, class:^(download)"
      "float, class:^(notification)"
      "float, class:^(error)"
      "float, class:^(splash)"
      "float, class:^(confirmreset)"
      "float, title:Open File"
      "float, title:branchdialog"
      "float, title:file-roller"
      "fullscreen, class:^(wlogout)"
      "float, title:wlogout"
      "fullscreen, title:wlogout"
      "idleinhibit focus, class:^(mpv)"
      "idleinhibit fullscreen, class:^(Firefox)"
      "idleinhibit focus, class:^(obsidian)$"
      "float, title:^(Media viewer)$"
      "float, title:^(Control de volumen)$"
      "float, title:^(Picture-in-Picture)$"
      "size 800 600, title:^(Control de volumen)$"
      "float, title:^(Authentication Required)$"
      "workspace 5,class:^(obsidian)$"
      "animation popin, class:^(thunar)$"
      "opacity 0.82 0.82, class:^(thunar)$"
      "opacity 0.92 0.92, class:^(obsidian)$"
    ];
    # windowrulev2 = [
    #   "workspace 5,class:^(obsidian)$"
    #   "animation popin, class:^(thunar)$"
    #   "opacity 0.82 0.82, class:^(thunar)$"
    #   "opacity 0.92 0.92, class:^(obsidian)$"
    # ];
  };
}
