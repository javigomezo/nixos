{
  config,
  vars,
  ...
}: let
  containerName = "immich-postgres";
  directories = [
    "${vars.dockerVolumes}/immich/postgres/data"
  ];
in {
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0";
        pull = "newer";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/immich/postgres/data:/var/lib/postgresql/data"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environmentFiles = [
          config.sops.templates."immich.env".path
        ];
        environment = {
          TZ = vars.timeZone;
          PUID = "1000";
          GUID = "1000";
          UMASK = "002";
          POSTGRES_INITDB_ARGS = "--data-checksums";
        };
        labels = {
          "traefik.enable" = "false";
          "glance.parent" = "immich";
          "glance.name" = "DB";
        };
      };
    };
  };
}
