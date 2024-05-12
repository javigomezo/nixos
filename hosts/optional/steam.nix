{
  #programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    #gamescopeSession.enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  };
}
