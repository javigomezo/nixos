{vars, ...}: let
  containerName = "lidarr";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/config"
    "${vars.dockerVolumes}/qbittorrent/data/downloads/"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        # image = "ghcr.io/linuxserver-labs/prarr:lidarr-plugins";
        image = "blampe/lidarr:lidarr-plugins-2.13.0.4661";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/config:/config"
          "${vars.dockerVolumes}/qbittorrent/data/downloads:/downloads"
          "/mnt/rclone/media/music:/music"
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
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "8686";
          "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
          "glance.name" = "Lidarr";
          "glance.parent" = "arr";
        };
      };
    };
  };

  systemd.services.podman-lidarr = {
    after = ["multi-user.target"];
  };
}
