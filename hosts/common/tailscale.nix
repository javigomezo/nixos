{
  config,
  lib,
  pkgs,
  vars,
  ...
}: {
  services.tailscale = {
    enable = true;
    useRoutingFeatures = lib.mkDefault "client";
    extraUpFlags = lib.mkIf (config.services.tailscale.useRoutingFeatures == "both") [
      "--advertise-exit-node"
      "--advertise-routes=10.0.0.0/24"
      "--reset"
    ];
  };

  boot.kernel.sysctl = lib.mkIf (config.services.tailscale.useRoutingFeatures == "both") {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  systemd.services."tailscale-optimization" = lib.mkIf (config.services.tailscale.useRoutingFeatures == "both") {
    path = with pkgs; [
      ethtool
    ];
    wantedBy = ["multi-user.target"];
    after = ["graphical.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe pkgs.ethtool} -K ${vars.mainInterface} rx-udp-gro-forwarding on rx-gro-list off";
    };
  };
}
