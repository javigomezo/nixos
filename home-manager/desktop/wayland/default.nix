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
      hyprpolkitagent
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
      teamspeak_client
      wl-clipboard
      xarchiver
      xfce.thunar
      xwayland
    ]);
}
