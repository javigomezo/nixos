{vars, ...}: let
  containerName = "koshelf";
in {
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "ghcr.io/devtigro/${containerName}:latest";
        pull = "newer";
        autoStart = true;
        volumes = [
          "/var/lib/syncthing/koreader/libros:/books:ro"
          "/var/lib/syncthing/koreader/database:/settings:ro"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          KOSHELF_TITLE = "Mi biblioteca";
          KOSHELF_TIMEZONE = vars.timeZone;
          KOSHELF_DAY_START_TIME = "00:00";
          KOSHELF_LANGUAGE = "es_ES";
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "3000";
          "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
          "glance.name" = "Koshelf";
        };
      };
    };
  };
}
