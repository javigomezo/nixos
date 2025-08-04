{
  lib,
  config,
  ...
}: {
  networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [config.services.esphome.port];
  services.esphome = {
    enable = true;
    allowedDevices = [];
  };
  environment.persistence."/persist".directories = lib.mkAfter [
    {
      directory = "/var/lib/private/esphome";
      user = "esphome";
      group = "esphome";
      mode = "u=rwx,g=rx,o=";
    }
  ];
}
