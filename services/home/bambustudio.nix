{vars, ...}: let
  containerName = "bambustudio";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/config"
    "${vars.dockerVolumes}/qbittorrent/data/downloads/"
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
          "${vars.dockerVolumes}/qbittorrent/data/downloads:/downloads"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
          DARK_MODE = "true";
        };
        extraOptions = [
          "--device=/dev/dri:/dev/dri"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "3000";
          "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
          # "glance.name" = "Sonarr";
          # "glance.parent" = "arr";
        };
      };
    };
  };

  systemd.services.podman-sonarr = {
    after = ["multi-user.target"];
  };
}
