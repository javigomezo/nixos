{lib, ...}: {
  networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [8181];
  services.tautulli = {
    enable = true;
    group = "plex";
    dataDir = "/var/lib/tautulli";
    configFile = "/var/lib/tautulli/config.ini";
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/tautulli";
      user = "plexpy";
      group = "plex";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
