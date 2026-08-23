{
  flake.modules.homeManager.hyprlandWindowRule = {...}: let
    rule = match: effects: {inherit match;} // effects;

    floatClasses = [
      "^(file_progress)"
      "^(confirm)"
      "^(dialog)"
      "^(download)"
      "^(notification)"
      "^(error)"
      "^(splash)"
      "^(confirmreset)"
    ];

    floatTitles = [
      "Open File"
      "branchdialog"
      "file-roller"
      "^(Media viewer)$"
      "^(Control de volumen)$"
      "^(Picture-in-Picture)$"
      "^(Authentication Required)$"
    ];
  in {
    wayland.windowManager.hyprland.settings = {
      window_rule =
        (map (c: rule {class = c;} {float = true;}) floatClasses)
        ++ (map (t: rule {title = t;} {float = true;}) floatTitles)
        ++ [
          (rule {class = "^(mpv)";} {idle_inhibit = "focus";})
          (rule {class = "^(Firefox)";} {idle_inhibit = "fullscreen";})
          (rule {title = "^(Control de volumen)$";} {size = "800 600";})

          (rule {class = "^(md.(?i)obsidian)$";} {
            idle_inhibit = "focus";
            workspace = "5";
            opacity = "0.92 0.92";
          })

          (rule {class = "^(thunar)$";} {
            animation = "popin";
            opacity = "0.82 0.82";
          })

          (rule {float = true;} {border_size = 0;})
        ];

      layer_rule = [
        (rule {namespace = "noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$";} {
          no_anim = true;
          blur = true;
          blur_popups = true;
          ignore_alpha = 0.5;
        })
      ];
    };
  };
}
