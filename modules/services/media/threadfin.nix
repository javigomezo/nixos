{
  flake.nixosModules.threadfin = {config, ...}: let
    containerName = "threadfin";
    directories = [
      "${config.my.vars.dockerVolumes}/${containerName}/data/config"
      "${config.my.vars.dockerVolumes}/${containerName}/data/temp"
    ];
  in {
    systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
    virtualisation.oci-containers = {
      containers = {
        ${containerName} = {
          image = "fyb3roptik/${containerName}:latest";
          pull = "newer";
          autoStart = true;
          volumes = [
            "${config.my.vars.dockerVolumes}/${containerName}/data/config:/home/threadfin/conf"
            "${config.my.vars.dockerVolumes}/${containerName}/data/config:/tmp/threadfin"
            "/etc/localtime:/etc/localtime:ro"
          ];
          environment = {
            TZ = config.my.vars.timeZone;
            PUID = "1000";
            GUID = "1000";
            UMASK = "002";
          };
          labels = {
            "traefik.enable" = "true";
            "traefik.http.routers.${containerName}.service" = "${containerName}";
            "traefik.http.services.${containerName}.loadbalancer.server.port" = "34400";
            "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
            "glance.name" = "Threadfin";
            "glance.parent" = "plex";
          };
        };
      };
    };
  };
}
