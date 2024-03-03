{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./browser
    ./gtk.nix
    ./hyprland
    ./hyprpaper
    ./kitty
    ./mako
    ./waybar
    ./wezterm
    ./wlogout
  ];

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
}
