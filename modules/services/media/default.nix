{self, ...}: {
  flake.nixosModules.mediaServices = {
    imports = with self.nixosModules; [
      audioBookShelf
      # ./overseerr
      plex
      jellyfin
      seerr
      prowlarr
      qbittorrent
      lidarr
      radarr
      sonarr
      slskd
      soulsync
      # ./suggestarr
      tautulli
      threadfin
    ];
  };
}
