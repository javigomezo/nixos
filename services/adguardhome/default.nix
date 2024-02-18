{ config, pkgs, lib, vars, ...}:

let
  directories = [
    "${vars.dockerVolumes}/adguardhome/data/workdir"
    "${vars.dockerVolumes}/adguardhome/config"
  ];
in
  {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
    virtualisation.oci-containers = {
      containers = {
        adguardhome = {
          image = "adguard/adguardhome:latest";
          autoStart = true;
          ports = [
            "53:53/udp"
            "3000:3000"
          ];
          volumes = [
            "${vars.dockerVolumes}/adguardhome/data/workdir:/opt/adguardhome/work"
            "${vars.dockerVolumes}/adguardhome/config:/opt/adguardhome/conf"
          ];
          environment = {
            TZ = vars.timeZone;
            PUID = "1000";
            GUID = "1000";
            UMASK = "002";
          };
  
        };
      };
    };
  }
