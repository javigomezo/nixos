{vars, ...}: let
  containerName = "overseerr";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/config"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "lscr.io/linuxserver/${containerName}:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/config"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "5055";
          "traefik.http.routers.${containerName}.middlewares" = "chain-no-oauth@file";
          "glance.name" = "Overseerr";
          "glance.parent" = "arr";
        };
      };
    };
  };
}
