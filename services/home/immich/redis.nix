{vars, ...}: let
  containerName = "immich-redis";
in {
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "redis:6.2-alpine";
        pull = "newer";
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
