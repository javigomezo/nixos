{
  flake.nixosModules.pi4bFirewall = {
    networking = {
      firewall = {
        enable = true;
        allowPing = true;
        allowedTCPPorts = [
          22
          9981
        ];
        allowedUDPPorts = [
          53
        ];
      };
    };
  };
}
