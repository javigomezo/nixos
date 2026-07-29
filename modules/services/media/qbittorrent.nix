{
  flake.nixosModules.qbittorrent = {config, ...}: let
    containerName = "qbittorrent";
    directories = [
      "${config.my.vars.dockerVolumes}/${containerName}/data/config"
      "${config.my.vars.dockerVolumes}/qbittorrent/data/downloads/"
    ];
  in {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
    virtualisation.oci-containers = {
      containers = {
        ${containerName} = {
          image = "lscr.io/linuxserver/${containerName}:latest";
          pull = "newer";
          networks = ["bridge"];
          autoStart = true;
          volumes = [
            "${config.my.vars.dockerVolumes}/${containerName}/data/config:/config"
            "${config.my.vars.dockerVolumes}/${containerName}/data/downloads:/downloads"
            "/etc/localtime:/etc/localtime:ro"
          ];
          environment = {
            TZ = config.my.vars.timeZone;
            PUID = "1000";
            GUID = "1000";
            WEBUI_PORT = "8080";
            UMASK = "002";
          };
          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${containerName}.service" = "${containerName}";
            "traefik.http.services.${containerName}.loadbalancer.server.port" = "8080";
            "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
            "glance.name" = "Qbittorrent";
            "glance.icon" = "si:qbittorrent";
            "glance.id" = "qbittorrent";
          };
        };
      };
    };
    networking = {
      firewall = {
        allowedTCPPorts = [
          50000
        ];
      };
    };
  };
}
