{
  lib,
  pkgs,
  outputs,
  ...
}: {
  imports =
    [
      ./browser
      ./gtk.nix
      ./hypridle
      ./hyprland
      ./hyprlock
      ./hyprpaper
      ./kitty
      ./mako
      ./waybar
      ./wezterm
      ./wlogout
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  home.packages = with pkgs; [
    ffmpeg
    gamescope
    grimblast
    killall
    mpv
    multiviewer-for-f1
    pavucontrol
    polkit-kde-agent
    protonup-qt
    qimgv
    rofi-wayland-unwrapped
    swaylock-effects
    wl-clipboard
    xfce.thunar
    xwayland
  ];
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
  };
}
