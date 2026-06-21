{
  self,
  inputs,
  ...
}: {
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    imports = with self.modules.homeManager; [
      cli
      monitors
      noctalia
      gtk
      cliphist
      kitty
      uwsm
      hyprlock
      hypridle
      firefox
      hyprland
    ];
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
        # hyprpolkitagent
        hmcl
        # input-leap
        killall
        stable.koodo-reader
        libfido2
        # localsend
        mgba
        mpv
        nanoboyadvance
        # mine.multiviewer-for-f1
        multiviewer-for-f1
        obsidian
        pavucontrol
        plex-desktop
        # plexamp
        proton-vpn
        qimgv
        stable.qmk
        teamspeak6-client
        unrar
        wtype
        wl-clipboard
        xarchiver
        thunar
        xwayland
      ]);
  };
}
