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
      # bambu-studio
      discord
      ffmpeg
      gamescope
      grimblast
      gparted
      hyprpolkitagent
      hmcl
      # input-leap
      killall
      koodo-reader
      localsend
      mpv
      # mine.multiviewer-for-f1
      multiviewer-for-f1
      obsidian
      pavucontrol
      plex-desktop
      plexamp
      protonup-qt
      qimgv
      qmk
      teamspeak6-client
      wl-clipboard
      xarchiver
      xfce.thunar
      xwayland
    ]);
}
