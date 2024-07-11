{
  inputs,
  config,
  pkgs,
  outputs,
  ...
}: {
  imports =
    [
      ./browser
      ./cliphist.nix
      ./gtk.nix
      ./hypridle
      ./hyprland
      ./hyprlock
      ./kitty
      ./mako
      ./waybar
      ./wezterm
      ./wofi.nix
      ./wlogout
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);

  home.packages =
    [
      inputs.bibata-modern-classic-hyprcursor.packages.${pkgs.system}.default
    ]
    ++ (with pkgs; [
      bambu-studio
      ffmpeg
      gamescope
      grimblast
      input-leap
      killall
      localsend
      mpv
      multiviewer-for-f1
      pavucontrol
      polkit-kde-agent
      protonup-qt
      qimgv
      qmk
      #rofi-wayland
      #rofi-wayland-unwrapped
      swaylock-effects
      wl-clipboard
      xarchiver
      xfce.thunar
      xwayland
    ]);
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    QT_QPA_PLATFORM = "wayland";
    LIBSEAT_BACKEND = "logind";
    FLAKE = "${config.home.homeDirectory}/nixos";
  };
}
