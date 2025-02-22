{
  config,
  vars,
  ...
}: {
  sops.secrets."keepalived.env" = {};
  services.keepalived = {
    enable = true;
    secretFile = config.sops.secrets."keepalived.env".path;
    vrrpInstances.VI = {
      state = "${vars.keepalivedState}";
      interface = "${vars.mainInterface}";
      virtualRouterId = 55;
      priority = vars.keepalivedPriority;
      unicastSrcIp = "${vars.keepalivedSrcIp}";
      unicastPeers = ["${vars.keepalivedDstIp}"];
      virtualIps = [{addr = "10.0.0.200/24";}];
      extraConfig = ''
        authentication {
          auth_type PASS
          auth_pass "$PASSWORD"
        }
      '';
    };
  };
}
