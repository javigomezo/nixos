{ config, pkgs, lib, vars, ...}:

{

  age.identityPaths = ["/home/javier/.ssh/id_ed25519"];
  age.secrets.keepalived = {
    file = ../../secrets/keepalived.age;
  };

  services.keepalived = {
    enable = true;
    secretFile = config.age.secrets.keepalived.path;
    vrrpInstances.VI = {
      state = "${vars.keepalivedState}";
      interface = "${vars.mainInterface}";
      virtualRouterId = 55;
      priority = 100;
      unicastSrcIp = "${vars.keepalivedSrcIp}";
      unicastPeers = [ "${vars.keepalivedDstIp}" ];
      virtualIps = [ { addr = "10.0.0.200/24";} ];
      extraConfig = ''
        authentication {
          auth_type PASS
          auth_pass "$PASSWORD"
        }
      '';
    };
  };
}
