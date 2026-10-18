{
  flake.nixosModules.esphome = {
    lib,
    config,
    pkgs,
    ...
  }: {
    networking.firewall.interfaces.podman0.allowedTCPPorts = lib.mkAfter [config.services.esphome.port];
    services.esphome = {
      enable = true;
      # address = "127.0.0.1";
      allowedDevices = [];
    };
    systemd.services.esphome = {
      path = [pkgs.esphome-device-builder pkgs.esphome];
      serviceConfig = {
        ExecStart = lib.mkForce "${pkgs.esphome-device-builder}/bin/esphome-device-builder --port ${toString config.services.esphome.port} /var/lib/esphome";
        ReadWritePaths = ["/var/lib/esphome"];
      };
    };
    environment.persistence."/persist".directories = lib.mkAfter [
      {
        directory = "/var/lib/esphome";
        user = "esphome";
        group = "esphome";
        mode = "0755";
      }
    ];
  };
}
