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
    home.pointerCursor.enable = true;

    services.gnome-keyring.enable = true;

    home.packages =
      [
        inputs.bibata-modern-classic-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
        (pkgs.symlinkJoin {
          name = "plezy-cage";
          paths = [pkgs.plezy];
          postBuild = ''
            rm $out/bin/plezy
            cat > $out/bin/plezy <<'EOF'
            #!${pkgs.runtimeShell}
            exec ${pkgs.cage}/bin/cage -d -- ${pkgs.plezy}/bin/plezy "$@"
            EOF
            chmod +x $out/bin/plezy
          '';
        })
      ]
      ++ (with pkgs; [
        # Artcraft Suite
        deckcraft
        # gridcraft
        wordcraft
        # bambu-studio
        discord
        ffmpeg
        foliate
        gamescope
        grimblast
        gparted
        # hyprpolkitagent
        hmcl
        # input-leap
        killall
        # koodo-reader
        libfido2
        libsecret
        # localsend
        mgba
        mpv
        # nanoboyadvance
        # mine.multiviewer-for-f1
        multiviewer-for-f1
        obsidian
        pavucontrol
        plex-desktop
        # plexamp
        proton-vpn
        qimgv
        seahorse
        stable.qmk
        teamspeak6-client
        unrar
        wtype
        wl-clipboard
        xarchiver
        thunar
        xwayland
        z-library-desktop
      ]);
  };
}
