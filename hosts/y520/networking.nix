{lib, ...}: {
  networking = {
    hostName = "y520";
    enableIPv6 = true;
    interfaces = {
      wlp3s0 = {
        useDHCP = lib.mkForce false;
        ipv4.addresses = [
          {
            address = "10.0.0.16";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "wlp3s0";
    };
    nameservers = ["10.0.0.2" "10.0.0.3"];
    # Enable networking
    networkmanager.enable = true;
  };
}
