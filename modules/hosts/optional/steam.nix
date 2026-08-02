{inputs, ...}: {
  flake.nixosModules.steam = {pkgs, ...}: {
    #programs.gamescope.enable = true;
    environment.systemPackages = [inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam];
    programs.steam = {
      enable = true;
      gamescopeSession.enable = false;
      remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      package = pkgs.steam.override {
        extraEnv = {
          LD_AUDIT = "${
            inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
          }/library-inject.so:${
            inputs.sls-steam.packages.${pkgs.stdenv.hostPlatform.system}.sls-steam
          }/SLSsteam.so";
        };
      };
    };
  };
}
