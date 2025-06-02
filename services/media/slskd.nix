{vars, ...}: let
  containerName = "slskd";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/config"
    "${vars.dockerVolumes}/qbittorrent/data/downloads/"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "${containerName}:latest";
        pull = "newer";
        autoStart = true;
        user = "1000:1000";
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/app"
          "${vars.dockerVolumes}/qbittorrent/data/downloads:/downloads"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
          SLSKD_REMOTE_CONFIGURATION = "true";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "5030";
          "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
          # "glance.name" = "Sonarr";
          # "glance.parent" = "arr";
        };
      };
    };
  };
}
