{
  nixpkgs = {
    config.allowUnfree = true;
    config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            gamescope
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libgdiplus
            libkrb5
            keyutils
          ];
      };
    };
  };
  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  };
}
