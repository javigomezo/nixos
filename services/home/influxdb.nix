{
  config,
  vars,
  ...
}: let
  containerName = "influxdb";
  directories = [
    "${vars.dockerVolumes}/${containerName}/data/data"
  ];
in {
  sops = {
    secrets = {
      "influxdb/init_mode" = {};
      "influxdb/init_username" = {};
      "influxdb/init_password" = {};
      "influxdb/init_org" = {};
      "influxdb/init_bucket" = {};
    };
    templates."influxdb.env" = {
      content = ''
        DOCKER_INFLUXDB_INIT_MODE=${config.sops.placeholder."influxdb/init_mode"}
        DOCKER_INFLUXDB_INIT_USERNAME=${config.sops.placeholder."influxdb/init_username"}
        DOCKER_INFLUXDB_INIT_PASSWORD=${config.sops.placeholder."influxdb/init_password"}
        DOCKER_INFLUXDB_INIT_ORG=${config.sops.placeholder."influxdb/init_org"}
        DOCKER_INFLUXDB_INIT_BUCKET=${config.sops.placeholder."influxdb/init_bucket"}
      '';
    };
  };
  systemd.tmpfiles.rules = map (x: "d ${x} 0775 javier javier - -") directories;
  virtualisation.oci-containers = {
    containers = {
      ${containerName} = {
        image = "lscr.io/linuxserver/${containerName}:alpine";
        autoStart = true;
        volumes = [
          "${vars.dockerVolumes}/${containerName}/data/data:/var/lib/influxdb2"
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
        };
        labels = {
          "traefik.enable" = "true";
          "traefik.http.routers.${containerName}.service" = "${containerName}";
          "traefik.http.services.${containerName}.loadbalancer.server.port" = "8086";
          "traefik.http.routers.${containerName}.middlewares" = "chain-oauth@file";
        };
      };
    };
  };
}
