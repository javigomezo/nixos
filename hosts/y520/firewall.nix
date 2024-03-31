{
  config,
  pkgs,
  lib,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [
        22
      ];
    };
  };
}
