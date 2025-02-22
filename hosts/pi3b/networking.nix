{
  networking = {
    wireless = {
      enable = true;
      allowAuxiliaryImperativeNetworks = true;
    };
    hostName = "pi3b";
    enableIPv6 = true;
    interfaces = {
      wlan0 = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "10.0.0.3";
            prefixLength = 24;
          }
        ];
      };
    };
    defaultGateway = {
      address = "10.0.0.1";
      interface = "wlan0";
    };
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
    ];
  };
}
