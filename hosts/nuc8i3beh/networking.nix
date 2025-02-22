{lib, ...}: {
  networking = {
    hostName = "nuc8i3beh";
    enableIPv6 = true;
    dhcpcd.enable = false;
    interfaces = {
      eno1 = {
        useDHCP = lib.mkForce false;
        ipv4.addresses = [
          {
            address = "10.0.0.2";
            prefixLength = 24;
          }
        ];
      };
      enp58s0u1 = {
        useDHCP = lib.mkForce false;
        ipv4.addresses = [
          {
            address = "11.0.0.2";
            prefixLength = 24;
          }
        ];
        mtu = 9000;
      };
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "eno1";
    };
    firewall = {
      allowedTCPPorts = [2049];
    };

    nameservers = ["9.9.9.11" "149.112.112.11"];
    # Enable networking
    networkmanager.enable = lib.mkForce false;
  };
}
