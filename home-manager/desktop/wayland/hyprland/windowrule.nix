{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float, file_progress"
      "float, confirm"
      "float, dialog"
      "float, download"
      "float, notification"
      "float, error"
      "float, splash"
      "float, confirmreset"
      "float, title:Open File"
      "float, title:branchdialog"
      "float, file-roller"
      "fullscreen, wlogout"
      "float, title:wlogout"
      "fullscreen, title:wlogout"
      "idleinhibit focus, mpv"
      "idleinhibit fullscreen, firefox"
      "float, title:^(Media viewer)$"
      "float, title:^(Control de volumen)$"
      "float, title:^(Picture-in-Picture)$"
      "size 800 600, title:^(Control de volumen)$"
      "float, title:^(Authentication Required)$"
    ];
    windowrulev2 = [
      "animation popin, class:^(thunar)$"
      "opacity 0.82 0.82, class:^(thunar)$"
    ];
  };
}
