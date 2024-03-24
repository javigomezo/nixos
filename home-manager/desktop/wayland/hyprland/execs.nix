{
  config,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    settings = {
      exec-once = [
        "hyprlock"
        "lxqt-policykit-agent"
        "hyprpaper"
        # "hyprctl setcursor Bibata-Modern-Cursor 24"
      ];
    };
  };
}
