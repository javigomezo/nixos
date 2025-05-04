{lib, ...}: {
  networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [32400];
  services.plex = {
    enable = true;
    openFirewall = false;
    accelerationDevices = ["/dev/dri/renderD128"];
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/plex";
      user = "plex";
      group = "plex";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
