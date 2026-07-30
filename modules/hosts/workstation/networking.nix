{
  flake.nixosModules.workstationNetworking = {
    networking = {
      hostName = "workstation"; # Define your hostname.
      enableIPv6 = true;
      interfaces.wlo1 = {
        ipv4.addresses = [
          {
            address = "10.0.0.10";
            prefixLength = 24;
          }
        ];
        useDHCP = false;
      };
      nameservers = [
        "10.0.0.2"
        "10.0.0.3"
      ];
      # Enable networking
      networkmanager = {
        enable = true;
        ensureProfiles.profiles = {
          "Wired Connection" = {
            connection = {
              id = "Wired Connection";
              type = "ethernet";
              interface-name = "enp7s0";
              autoconnect = true;
            };
            ipv4 = {
              method = "manual";
              addressess = "10.100.0.140/24";
              gateway = "10.100.0.1";
              dns = "100.107.139.7;100.66.64.44";
            };
          };
        };
      };
    };
  };
}
