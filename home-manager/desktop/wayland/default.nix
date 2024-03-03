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
    duf
    eza
    ffmpeg
    gamescope
    git
    grimblast
    killall
    nitch
    nixd
    htop
    mpv
    multiviewer-for-f1
    pavucontrol
    polkit-kde-agent
    protonup-qt
    (python3.withPackages (ps: with ps; [requests]))
    qimgv
    ripgrep
    rofi-wayland-unwrapped
    stow
    swaylock-effects
    tmux
    vim
    wl-clipboard
    xfce.thunar
    xwayland
  ];
}
