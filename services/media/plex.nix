{vars, ...}: let
  containerName = "plex";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/library"
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
          "${vars.dockerVolumes}/${containerName}/data/library:/config"
          "/mnt/TVShows:/data/tvshows"
          "/mnt/Movies:/data/movies"
          #"/media/music:/data/music"
          "/mnt/rclone/media/music:/data/music"
          "/dev/shm:/transcoding"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        extraOptions = [
          "--device=/dev/dri:/dev/dri"
        ];
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "32400";
          "traefik.http.routers.${containerName}.middlewares" = "chain-no-oauth@file";
        };
      };
    };
  };

  systemd.services.podman-plex = {
    after = ["multi-user.target"];
  };
}
