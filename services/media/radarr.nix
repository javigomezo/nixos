{vars, ...}: let
  containerName = "radarr";
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
        ports = [
          "127.0.0.1:7878:7878"
        ];
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/config"
          "${vars.dockerVolumes}/qbittorrent/data/downloads:/downloads"
          "/mnt/Movies:/data/movies"
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
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "7878";
          "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
          "glance.name" = "*Arr Stack";
          "glance.icon" = "si:radarr";
          "glance.id" = "arr";
        };
      };
    };
  };

  systemd.services.podman-radarr = {
    after = ["multi-user.target"];
  };
}
