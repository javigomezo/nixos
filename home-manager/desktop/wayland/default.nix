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
      inputs.bibata-modern-classic-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
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
      stable.koodo-reader
      libfido2
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
      stable.qmk
      teamspeak6-client
      unrar
      wl-clipboard
      xarchiver
      thunar
      xwayland
    ]);
}
