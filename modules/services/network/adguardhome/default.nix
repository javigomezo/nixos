{self, ...}: {
  flake.nixosModules.adguardHome = {
    config,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.adguardHomeConfig
    ];

    services.adguardhome = {
      enable = true;
      openFirewall = true;
      mutableSettings = false;
    };

    systemd.services.adguardhome = {
      preStart = lib.mkAfter ''
        cp ${config.sops.templates."adguard_config.yaml".path} /var/lib/AdGuardHome/AdGuardHome.yaml
      '';
    };
    networking.firewall = {
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
      interfaces = {
        "tailscale0".allowedTCPPorts = [53];
        "tailscale0".allowedUDPPorts = [53];
      };
    };
  };
}
