{
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
    networkmanager.enable = true;
  };
}
