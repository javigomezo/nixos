{vars, ...}: let
  containerName = "immich-redis";
in {
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "redis:6.2-alpine@sha256:905c4ee67b8e0aa955331960d2aa745781e6bd89afc44a8584bfd13bc890f0ae";
        autoStart = true;
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
        };
        labels = {
          "traefik.enable" = "false";
        };
      };
    };
  };
}
