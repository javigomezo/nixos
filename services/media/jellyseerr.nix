{
  config,
  lib,
  ...
}: {
  networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [config.services.jellyseerr.port];
  services.jellyseerr = {
    enable = true;
    openFirewall = false;
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/private/jellyseerr";
      user = "jellyseerr";
      group = "jellyseerr";
      mode = "u=rwx,g=rx,o=rx";
    }
  ];
}
