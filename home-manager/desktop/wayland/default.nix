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
    ./mako
    ./waybar
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
    pavucontrol
    polkit-kde-agent
    protonup-qt
    (python3.withPackages (ps: with ps; [requests]))
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
