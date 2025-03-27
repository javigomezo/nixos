{
  config,
  vars,
  ...
}: let
  containerName = "immich";
  directories = [
    "${vars.dockerVolumes}/immich/server/data/upload"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      "${containerName}" = {
        image = "ghcr.io/immich-app/${containerName}-server:release";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/immich/server/data/upload:/usr/src/app/upload"
          "/etc/localtime:/etc/localtime:ro"
        ];
        extraOptions = [
          "--device=/dev/dri:/dev/dri"
        ];
        environmentFiles = [
          config.sops.templates."immich.env".path
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
          REDIS_HOSTNAME = "immich-redis";
          DB_HOSTNAME = "immich-postgres";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "2283";
          "traefik.http.routers.${containerName}.middlewares" = "chain-no-oauth@file";
          "glance.name" = "Immich";
          "glance.icon" = "si:immich";
          "glance.id" = "immich";
        };
      };
    };
  };
}
