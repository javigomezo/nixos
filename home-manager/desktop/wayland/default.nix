{
  inputs,
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
      ./uwsm
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
      gparted
      input-leap
      killall
      localsend
      mpv
      multiviewer-for-f1
      obsidian
      pavucontrol
      plexamp
      # polkit-kde-agent
      hyprpolkitagent
      protonup-qt
      qimgv
      qmk
      wl-clipboard
      xarchiver
      xfce.thunar
      xwayland
    ]);
}
