{
  lib,
  config,
  ...
}: {
  sops = {
    secrets = {
      home_psk_raw = {};
    };
    templates."network.env" = {
      owner = "wpa_supplicant";
      group = "wpa_supplicant";
      content = ''
        psk_wifi=${config.sops.placeholder.home_psk_raw}
      '';
    };
  };

  networking = {
    # useNetworkd = true;
    wireless = {
      enable = true;
      interfaces = ["wlan0"];
      secretsFile = config.sops.templates."network.env".path;
      allowAuxiliaryImperativeNetworks = true;
      networks.WIFI_CASA_5G.pskRaw = "ext:psk_wifi";
      extraConfig = "country=ES";
    };
    hostName = "pi4b";
    enableIPv6 = true;
    interfaces = {
      wlan0 = {
        useDHCP = lib.mkForce false;
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
