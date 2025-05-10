{lib, ...}: {
  networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [8181];
  services.tautulli = {
    enable = true;
    group = "plex";
    dataDir = "/var/lib/tautulli";
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/tautulli";
      user = "plexpy";
      group = "tautulli";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
